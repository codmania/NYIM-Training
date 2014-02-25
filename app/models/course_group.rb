class CourseGroup < ActiveRecord::Base

  extend FriendlyId
  friendly_id :url_name, :use => :slugged

  def url_name
    "#{name}"
  end

  def to_param
    "#{super}__#{site(:slug)}"
  end

  default :active => true, :short_name => proc { |r| r.name }

  acts_as_list :column => 'pos'
  # automatically done after save, no access
  #validates_numericality_of :pos, :integer_only => true

  hidden_attribute_match = /^(pos|active|course_group_id)$/
  all_fields_blank       = proc { |attrs| attrs.all? { |a, v| hidden_attribute_match.match(a) || v.blank? } }

  has_many :courses, :dependent => :destroy, :order => 'pos ASC'
  accepts_nested_attributes_for :courses, :allow_destroy => false, :reject_if => all_fields_blank

  has_many :testimonials, :through => :courses

  has_many :scheduled_courses, :through => :courses

  validates :name, :short_name, :presence => true, :uniqueness => true

  #before_validation :init

  def init
    self.short_name = name
  end

  def to_menu
    short_name || name.truncate(10)
  end

  has_asset :outline, :description, :pricing, :keywords

  def title
    name
  end

  scope :active, (lambda {
    where(:active.eq => true).order('pos ASC', 'name DESC')
  })

end
