class Feedback < ActiveRecord::Base

  default :read => false, :display => true, :recommend => true, :reference => true

  validates :text, :presence => true

  TEXT_ATTRS = [:text, :general, :most_useful, :least_useful,
                :knowledge, :patience, :location, :cleanliness, :materials,
                :how_to_improve, :why_nyim]

  RATE_ATTRS = [:knowledge, :patience, :location, :cleanliness, :materials]
  unless Rails.env.production?
    before_validation do |record|
      TEXT_ATTRS.each { |a| record.send("#{a}=", '-') if record.send(a).blank? }
      RATE_ATTRS.each { |a| record.send("#{a}=", '3') if record.send(a).blank? || record.send(a) == 0 }
    end
  end

  #validates *(TEXT_ATTRS.dup << { :presence => true })
                               #validates *(RATE_ATTRS.dup << { :inclusion => 1..5 })
  validates :text, :how_to_improve, :presence => true

  all_fields_blank = proc { |attrs| attrs.all? { |a, v| a.to_sym == :user_id || v.blank? } }

  has_many :comments, :order => 'created_at ASC', :autosave => true
  accepts_nested_attributes_for :comments, :allow_destroy => true, :reject_if => all_fields_blank

  has_one :signup
  has_one :testimonial, :autosave => true
  belongs_to :scheduled_course #, :through => :signup
  has_one :student, :through => :signup
  has_one :course, :through => :scheduled_course
  has_one :teacher, :through => :scheduled_course

  #validates :scheduled_course, :existence => { :message => 'course id not set' } # SENT VIA FORM

  validates_each :signup, :on => :create, :allow_nil => true do |record, attr, value|
    record.errors.add 'class', 'has to be completed before you leave feedback' unless record.signup.can_have_feedback?
  end

  before_validation :set_testimonial

  def set_testimonial
    name                = student && student.abbreviated_name_with_company
    self.testimonial    ||= Testimonial.new(:text       => text,
                                            :course_id  => scheduled_course.course_id,
                                            :teacher_id => scheduled_course.teacher_id,
                                            :name       => name)
    testimonial.display = display
    testimonial.read    = read
    testimonial.name    = name
    self
  end

  after_update :save_testimonial

  def save_testimonial
    testimonial.save(:validate => false)
  end

  scope :student_full_name_with_email, (lambda do |a|
    joins(:student).where(:student => { :email.eq => Student.extract_email(a) })
  end)

  search_methods :student_full_name_with_email
end
