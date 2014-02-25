class ScheduledSession < ActiveRecord::Base

  #attr_accessible :all

  default :duration => proc { site(:default_session_duration) }, :active => true

  belongs_to :scheduled_course

  #validates_existence_of :scheduled_course

  validates :starts_at, :date => { :after => Time.now }, :on => :create, :allow_blank => false
  #validates_date_time :when

  before_validation :set_ends_at

  def set_ends_at
    self.ends_at = starts_at + duration.minutes
  end

  after_save :update_course_times, :update_course_hours
  after_destroy :update_course_times, :update_course_hours

  validates :duration, :inclusion => 1..999

  def to_s
    # 2 March 1pm-3:15pm
    desc = "#{starts_at.to_s}-#{ends_at.to_s(:time)}"
    ScheduledCourse.format_time(desc)
  end

  def update_course_times
    # this is also called if a lesson is made inactive
    # if the whole course is made inactive (and therefore all the lessons), then starts_at is set to nil
    # courses, controller should really make sure only active courses are selected
    unless scheduled_course.changed?
      first = self.class.active.sisters(:of => self).first
      last  = self.class.active.sisters(:of => self).last

      starts_at                  = first ? first.starts_at : nil
      ends_at                    = last ? last.ends_at : nil
      scheduled_course.starts_at = starts_at
      scheduled_course.ends_at   = ends_at
      scheduled_course.save(:validate => false)
    end
  end

  # course hours are automatically updated
  def update_course_hours
    unless scheduled_course.changed?
      scheduled_course.hours ||= 0
      scheduled_course.hours = self.class.active.sisters(:of => self).map { |s| s.duration.minutes/3600.00 }.sum
      scheduled_course.save(:validate => false)
    end
  end

  scope :sisters, lambda { |*o|
    options = o.first || { }
    where(:scheduled_course_id => options[:of].scheduled_course_id).order('starts_at ASC')
  }

  def future?
    starts_at > Time.now
  end

  alias_method :upcoming?, :future?

  def past?
    starts_at + duration.minutes < Time.now
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

  scope :active, lambda { |*o|
    where(:active => true)
  }

  scope :future, lambda { |*o|
    where(:starts_at.gt => Time.now)
  }

  scope :current, lambda { |*o|
    where(:ends_at.gt => Time.now)
  }

  scope :past, lambda { |*o|
    where(:ends_at.lt => Time.now)
  }

  scope :running, lambda { |*o|
    current.where(:starts_at.lt => Time.now)
  }

  scope :calendar_from_dt, lambda { |*o|
    where(:starts_at.gt => Time.at(o.first.to_i).to_formatted_s(:db))
  }

  scope :calendar_to_dt, lambda { |*o|
    where(:ends_at.lt => Time.at(o.first.to_i).to_formatted_s(:db))
  }

  search_methods :calendar_from_dt, :calendar_to_dt

  def to_calendar
    { :id          => id,
      :title       => to_s,
      :description => scheduled_course.name,
      :start       => "#{starts_at.iso8601}",
      :end         => "#{ends_at.iso8601}",
      :allDay      => false,
      :recurring   => false }
  end

  class << self
    alias_method :upcoming, :future
  end
  #error_names

end
