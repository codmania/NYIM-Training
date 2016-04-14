class Student < User

  attr_accessor :mandatory, :company_name

  self.inheritance_column = "role"
  #belongs_to :owner, :class_name => 'User', :foreign_key => :parent_id

  belongs_to :company#, :autosave => true

  validates_associated :company
  accepts_nested_attributes_for :company, :reject_if => proc { |attrs| attrs['mandatory'] != "true" }

  validates :company, :existence => true,  :unless => proc { |r| r.company && r.company.new_record? }
  validates :company_name, :presence => true, :on => :create, :unless => proc { |r| r.company }

  before_validation :set_company

  def set_company
    self.company ||= Company.find_or_create_by_name company_name  unless company_name.blank?
  end

  belongs_to :created_by, :class_name => 'User'
  has_many :students, :foreign_key => :created_by_id
  belongs_to :parent, :class_name => 'User'
  has_many :children, :foreign_key => :parent_id, :class_name => 'User'

  #all_fields_blank = proc { |attrs| attrs.all? { |a| a.blank? } }
  attr_accessible :phone_numbers_attributes, :addresses_attributes, :company_attributes

  has_many :addresses, :as => :addressable, :order => 'created_at DESC',  :dependent => :destroy, :autosave => true
  accepts_nested_attributes_for :addresses, :allow_destroy => :true ,  :reject_if =>  proc { |attrs| attrs['mandatory'] != "true"  && attrs['street_1'].blank? && attrs['postal_code'].blank? }

  has_many :phone_numbers, :as => :phoneable, :order => 'created_at DESC',  :dependent => :destroy, :autosave => true
  accepts_nested_attributes_for :phone_numbers, :allow_destroy => :true ,  :reject_if => proc { |attrs| attrs['mandatory'] != "true" && attrs['number'].blank? }

  def phone_number
    phone_numbers.first
  end

  has_many :feedbacks

  has_many :credit_cards

  def cards(store)
    credit_cards.select { |c| c.available?(store) }
  end

  has_many :signups
  has_many :scheduled_courses, :through => :signups
  has_many :courses, :through => :signups

  has_many :signed_up, :class_name => 'Signup', :conditions => ["signups.purchase_type IS TRUE AND signups.status IN ('pending', 'checked_out', 'confirmed', 'completed')"]
  has_many :signed_up_classes, :class_name => 'ScheduledCourse', :through => :signed_up, :source => :scheduled_course
  has_many :signed_up_courses, :class_name => 'Course', :through => :signed_up, :source => :course

  has_many :attendances, :class_name => 'Signup', :conditions => ["signups.purchase_type IS TRUE AND signups.status IN ('confirmed', 'completed')"]
  has_many :attended_classes, :class_name => 'ScheduledCourse', :through => :attendances, :source => :scheduled_course
  has_many :attended_courses, :class_name => 'Course', :through => :attendances, :source => :course

  has_many :completions, :class_name => 'Signup', :conditions => ["signups.purchase_type IS TRUE AND signups.status = 'completed'"]
  has_many :completed_classes, :class_name => 'ScheduledCourse', :through => :completions, :source => :scheduled_course
  has_many :completed_courses, :class_name => 'Course', :through => :completions, :source => :course

  has_many :waiting_signups, :class_name => 'Signup', :conditions => ["signups.purchase_type IS TRUE AND signups.status = 'completed'"]
  has_many :waiting_classes, :class_name => 'ScheduledCourse', :through => :waiting_signups, :source => :scheduled_course
  has_many :waiting_courses, :class_name => 'Course', :through => :waiting_signups, :source => :course

  def self.find_by_full_name_with_email(string,user)
    return unless user
    email = extract_email(string)
    student = find_by_email email unless email.blank?
    student if student && student.created_by == user || user.admin?
  end

  def signed_up?(course)
    case course
    when ScheduledCourse then signed_up_classes.include?(course)
    when Course then signed_up_courses.include?(course)
    end
  end

  def attending?(course)
    case course
    when ScheduledCourse then attended_classes.include?(course)
    when Course then attended_courses.include?(course)
    end
  end

  def waiting?(course)
    case course
    when ScheduledCourse then waiting_classes.include?(course)
    when Course then waiting_courses.include?(course)
    end
  end

  def completed?(course)
    case course
    when ScheduledCourse then completed_classes.include?(course)
    when Course then completed_courses.include?(course)
    end
  end

  has_many :submissions, :class_name => 'Signup', :foreign_key => :submitter_id

  has_many :payments, :foreign_key => :submitter_id

  def returning_customer?
    @returning_customer ||= submissions.where(:status.not_in => ['waiting']).count > 1
  end

  def shopping_cart(student_id=id)
    Signup.shopping_cart(student_id)
  end

#validates_existence_of :company
#error_names :addresses_addressable_id => false, :phone_numbers_phoneable_id => false, :addressable_type => false, :phone_numbers_phoneable_type => false
end

