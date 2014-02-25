class ScheduledCourse < ActiveRecord::Base

  extend FriendlyId
  friendly_id :url_name, :use => :slugged

  def url_name
    "#{name} #{to_menu}"
  end

  def to_param
    "#{super}__#{site(:slug)}"
  end

  has_asset :description, :keywords

  include ScheduledCourse::Validations
  include ScheduledCourse::Scopes

  default :seats    => proc { site(:default_course_seats) },
    :hours    => proc { site(:default_course_hours) },
    :active   => true,
    :location => proc { Location.first }

  belongs_to :teacher
  belongs_to :course
  belongs_to :location
  has_one :course_group, :through => :course

  hidden_attribute_match = /^(active|scheduled_course_id|duration)$/
  all_fields_blank       = proc { |attrs| attrs.all? { |a, v| hidden_attribute_match.match(a) || v.blank? } }

  has_many :scheduled_sessions, :order => 'starts_at ASC'
  accepts_nested_attributes_for :scheduled_sessions, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:starts_at].blank? } #all_fields_blank

  has_many :signups

  has_many :attendances, :class_name => 'Signup', :conditions => { :purchase_type => true, :status => ['confirmed', 'completed'] }
  has_many :attendants, :class_name => 'Student', :through => :attendances, :source => :student
  has_many :feedbacks, :through => :attendances
  has_many :feedbacks

  composed_of :price, :class_name => 'Money',
    :mapping            => [%w(price cents)],
    :allow_nil          => true,
    :converter          => proc { |c| c.blank? ? Struct.new(:cents).new : Money.new(c.to_f * 100) }

  before_validation :set_hours, :set_seats

  def promotional?
    promotion_expires_at && promotion_expires_at > Time.now
  end

  def set_seats
    self.seats_available = seats if new_record?
  end

  def os
    super || course.ifnil?(&:os)
  end

  def price
    cents = read_attribute('price')
    cents && Money.new(cents) || course.ifnil?(&:price)
  end

  delegate :name, :short_name, :resources_asset_name, :to => :course

  def promotional_discount
    super || course.ifnil?(&:promotional_discount)
  end

  def promotion_expires_at
    super || course.ifnil?(&:promotion_expires_at)
  end

  def full_name
    "#{name} (#{to_menu})"
  end

  def set_hours
    #:TODO: why 3600????!!
    self.hours = 0
    scheduled_sessions.each do |l|
      l.set_ends_at
      self.hours += l.duration.minutes/3600.00
    end
    self.starts_at = scheduled_sessions.first.ifnil? &:starts_at
    self.ends_at   = scheduled_sessions.last.ifnil? &:ends_at
  end

  def start_time
    starts_at ? self.class.format_time(starts_at.to_s) : ''
  end

  def self.format_time(desc)
    # delete leading 0 of hour
    desc.gsub!(/([\-\ ]) *0/, '\1')
    # delete 0 minute of hour
    desc.gsub!(/\:00/, '')
    # lowercase AM/PM
    desc.gsub!(/AM/, 'am')
    desc.gsub!(/PM/, 'pm')
    # delete leading zero from day
    #desc.gsub!(/^([^ ]+) 0/, '\1 ')
    desc
  end

  def to_menu
    starts_at ? start_time : id
  end

  def to_dropdown
    "#{to_menu} (#{show_seats})"
  end

  def full_notice
    full? ? 'on signup you will be added to our waiting list and receive email notification once there are free seats available' : ''
  end

  def show_seats_available
    full? ? 'full' : "#{seats_available}/#{seats}"
  end

  def show_seats
    show_seats_available
    #full? ? 'full' : "#{seats_available} #{seats_available > 1 ? 'seats' : 'seat' }"
  end

  def show_attendees
    "#{seats-seats_available}/#{seats}"
  end

  def future?
    !starts_at || starts_at > Time.now
  end

  alias_method :upcoming?, :future?

  def past?
    ends_at && ends_at < Time.now
  end

  def current?
    !past?
  end

  def running?
    !past? && !future?
  end

  def status
    (future? ? :upcoming : (past? ? :past : :current)).to_s
  end

  def recently_became_past
    @recently_became_full
  end

  # this cronjob should ideally run
  def starts_tomorrow?
    future? && starts_at < site(:course_check_interval).since
  end

  def ended_yesterday?
    past? && ends_at > site(:course_check_interval).ago
  end

  # available seat
  def full?
    seats_available == 0
  end

  def not_full?
    !full?
  end

  def has_alternative_class?
    self.class.alternative(:course => self).count > 0
  end

  def booked?
    seats != seats_available
  end

  def recently_became_full?
    !!@recently_became_full
  end

  def recent_vacancy?
    !!@recent_vacancy
  end

  def reserve(n=1)
    raise(ArgumentError, "1 < #{n} < #{seats_available}") if n < 1 || n > seats_available
    self.seats_available  -= n
    @recently_became_full = full?
    true
  end

  def unreserve(n=1)
    raise(ArgumentError, "1 < #{n} < #{seats - seats_available}") if n < 1 || n > seats - seats_available
    was_full             = full?
    self.seats_available += n
    @recent_vacancy      = was_full && !full?
    true
  end

  def add_seats(number = 1)
    was_full             = full?
    self.seats           += number
    self.seats_available += number
    @recent_vacancy      = was_full && !full?
    true
  end

  def remove_seats
    return false if full?
    self.seats           -= 1
    self.seats_available -= 1
    true
  end

  def close
    return true if full?
    self.seats            -= self.seats_available
    self.seats_available  = 0
    @recently_became_full = full?
  end

  def open # this is dangerous only do if associated signups are cleared
    self.seats_available  = seats
  end

  [:open, :close, :remove_seats, :add_seats, :reserve, :unreserve].each do |f|
    define_method :"#{f}!" do |*args|
      send(f, *args) && save(:validate => false)
    end
  end

  def times
    scheduled_sessions.map(&:to_s).join(', ')
  end

  def description
    "#{times} - #{show_seats}"
  end

  def to_calendar
    starts_at ?
      { :id            => id,
        :course_id     => course_id,
        :title         => '    ',
        :popup_title   => name,
        :trainer_photo => teacher.photo.url(:small),
        :trainer_name  => teacher.name,
        :info          => description,
        :start         => starts_at.iso8601,
        #:end => "#{ends_at.iso8601}",
        :allDay        => false,
        :recurring     => false } : {}
  end

  after_save :notify_when_seat_available

  def notify_when_seat_available
    if recent_vacancy? && site(:notify_when_seat_available)
      NyimJobs::SeatAvailable.new(:course => self).launch
    end
  end

end
