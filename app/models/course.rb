require 'date_validator'


class Course < ActiveRecord::Base

  extend FriendlyId
  friendly_id :url_name, :use => :slugged

  def url_name
    "#{name}"
  end

  def to_param
    "#{super}__#{site(:slug)}"
  end

  default :active               => true,
          :promotional_discount => 0,
          :promotion_expires_at => proc { site(:default_promotion_duration).month.from_now }

  belongs_to :course_group
  validates :course_group, :existence => true

  acts_as_list :scope => :course_group, :column => 'pos'
  validates :pos, :hours, :numericality => { :integer_only => true, :allow_blank => true }

  hidden_attribute_match = /^(active|course_id|location_id)$/
  all_fields_blank       = proc { |attrs| attrs.all? { |a, v| hidden_attribute_match.match(a) || v.blank? } }

  has_many :scheduled_courses, :dependent => :destroy, :order => 'starts_at ASC'
  accepts_nested_attributes_for :scheduled_courses, :allow_destroy => false, :reject_if => all_fields_blank

  has_many :feedbacks, :through => :scheduled_courses
  has_many :testimonials

  has_many :teachers, :through => :scheduled_courses

  composed_of :price, :class_name => 'Money',
              :mapping            => [%w(price cents)],
              :allow_nil          => true,
              :converter          => proc { |c| c.blank? ? Struct.new(:cents).new : Money.new(c.to_f * 100) }

  def price
    cents = read_attribute('price')
    cents && Money.new(cents)
  end

  validates :name, :short_name, :presence => true, :uniqueness => true

  validates_each :os, :allow_blank => true do |record, attr, value|
    os = site(:os)
    record.errors.add attr, "(%s) not a valid OS (%s)" % [value, os.join(',')] unless os.include?(value)
  end

  validates_numericality_of :promotional_discount, :integer_only => true, :in => 0..100, :allow_nil => true
  validates_presence_of :promotion_expires_at, :if => proc { |c| c.promotional_price_set? }
  validates :promotion_expires_at, :date => true, :allow_blank => true

  # blank out promotion expiration unless promotional is set to a promotion
  before_validation :set_promotion_expires_at, :set_os, :set_short_name

  def set_os
    self.os = nil if os.blank?
  end

  def set_short_name
    self.short_name = name if short_name.blank?
  end

  def scheduled_courses_available
    scheduled_courses.upcoming.active
  end

  def promotional_price_set?
    (promotional_discount || promotional_price || 0) > 0
  end

  def set_promotion_expires_at
    unless promotional_price_set?
      self.promotion_expires_at = nil
    end
  end

  def promotional?
    promotion_expires_at && promotion_expires_at > Time.now
  end

  def sale_price
    if promotional?
      if promotional_price
        promotional_price
      else
        price * (1.0 - promotional_discount.to_f/100.0)
      end
    else
      price
    end
  end

  def to_menu
    short_name || name.truncate(10)
  end

  def to_dropdown
    "#{name} (#{upcoming_scheduled_courses_count})"
  end

  has_asset :resources, :outline, :description, :keywords

  scope :promotions, (lambda {
    where(:promotion_expires_at.gt => Time.now).order('promotional_discount DESC').limit(5)
  })

  scope :active, (lambda {
    joins(:course_group).where(:course_group => { :active.eq => true }, :active.eq => true).order('pos ASC', 'name DESC')
  })

end
