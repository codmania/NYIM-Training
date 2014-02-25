class Signup < ActiveRecord::Base

  include Signup::Validations
  include Signup::Price
  include Signup::Events
  include Signup::StateMachineHooks
  include Signup::Notifications
  include Signup::Scopes

  define_state_scopes

  state_machine :status, :initial => :pending do
  end
  default :purchase_type => true

  #include ActsAsSignupStateMachine
  belongs_to :scheduled_course
  belongs_to :course
  belongs_to :submitter, :class_name => 'User'
  belongs_to :created_by, :class_name => 'User'

  belongs_to :feedback
  accepts_nested_attributes_for :feedback#, :reject_if => proc { |attrs| attrs['mandatory'] != 'true' }

  attr_accessor :allow_double_booking, :too_late, :rescheduled_course_id, :updated_by, :student_email, :retake

  belongs_to :student#, :autosave => true
  accepts_nested_attributes_for :student, :reject_if => proc { |attrs| attrs['mandatory'] != 'true' }

  belongs_to :payment # successful payment
  has_and_belongs_to_many :failed_payments, :class_name => 'Payment', :join_table => 'failed_payments_purchases'

  # delegate course attributes to course (not price)
  delegate :name, :full_name, :scheduled_sessions, :starts_at, :ends_at, :hours, :teacher,
  :past?, :future?, :current?, :running?, :upcoming?, :full?, :not_full?, :booked?,
  :resource_path, :promotional?, :promotional_discount,
  :has_alternative_class?, :seats, :seats_available, :times, :location,
  :to => :scheduled_course

  delegate :email, :phone_number, :to => :student

  # before validation we set submitter to the student if not already set
  # this happens if and only if the signup is done from not-logged in state
  before_validation :set_submitter

  def set_submitter
    student_found = Student.find_by_full_name_with_email(student_email,created_by)
    self.student = student_found if student_found
    # created_by should be assigned in model defaults with logged in otherwise student
    self.created_by ||= student
    # submitter is student creator or (if admin creator) first added student passed by param or student
    self.submitter ||= created_by.is_a?(Student) ? created_by : student
    # creator takes ownership of new student
    student.created_by = created_by if student && student.new_record? && student != created_by
    student.parent = submitter if student && student.new_record? && submitter && !submitter.new_record?
    self.course ||= scheduled_course.course if scheduled_course
  end

  def to_menu
    full_name
  end

  def course_confirmation_required?
    site(:course_confirmation_required)
  end

  def get_double_booking_on_class
    @double_booking_on_class
  end

  after_create :forget_waiting_sisters

  def forget_waiting_sisters
    sisters.waiting.each(&:destroy)
    #sisters.waiting.all.each { |w| w.reload.forget if w.can_forget? }
    true
  end

end
