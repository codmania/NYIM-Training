module Signup::Validations
    def self.included(base)
      base.class_eval do
        
        def has_new_student?
          student && student.new_record?
        end
        
        def double_booking
          has_new_student? ? [] : cousins.attendance
        end
        
        def double_booking_on_class
          has_new_student? ? [] : sisters.attendance
        end
        
        def course_can_be_booked?
          !pending? || to_be_retake? || allow_double_booking || double_booking.all? { |c| c.waiting? || c.canceled? || c.released? }
        end

        def class_can_be_booked?
          double_booking_on_class.all? { |c| c.waiting? || c.released? } || cancelation?
        end
        

      validates :scheduled_course, :presence => { :message => ': you have to choose a class' }

      validates :scheduled_course,  :allow_nil => true, :existence => { :message => 'does not exist' }

      validates :student,
  :existence => { :conditions => { "has to be a student" => :student? } },
  :unless => proc { |r| r.student && r.student.new_record? }
      # modifying ok and retaking on the same class also ok

      # we have to do more sophisticated uniqueness validation
      #validates_uniqueness_of :scheduled_course_id, :on => :create, :if => Proc.new{ |r| r.parent.nil? }, :scope => :student_id,
      #:message => "is invalid: already signed up for this class"

      # one cannot subscribe to the same course, hopefully one can retake a past course
      # this is important if one cancels and then retakes after it is past
      validates_each :scheduled_course,
  #:on => :create,
  :if => Proc.new{ |r| r.student.is_a?(Student) && r.scheduled_course.is_a?(ScheduledCourse) } do |record,attr_name,value|
      # you are allowed to sign up for the same course if ...
        record.errors.add attr_name, "already signed up to another class (use reschedule)" unless record.course_can_be_booked? || record.waiting?

        record.errors.add attr_name, "is full" if record.full? && record.pending? && record.attendance?
        #record.errors.add attr_name, "is not full" if record.not_full? && record.waiting? && record.attendance?
        record.errors.add attr_name, "is not attendance" if record.waiting? && !record.attendance?

        # you are allowed to sign up for the same scheduled course if ...
        record.errors.add attr_name, "is invalid: already signed up/put on waiting list for this class" unless record.class_can_be_booked? 
      end

      validates_each :scheduled_course, :on => :update, :if => Proc.new{ |r| r.confirmed? } do |record,attr_name,value|
        record.errors.add attr_name, "is starting within 2 business days. Canceling is not possible any more." if record.too_late
      end

      validates :created_by, :existence => true, :allow_nil => true

      validates :submitter, :existence => true, :allow_nil => true, :unless => Proc.new { |r| r.submitter && r.submitter.new_record? }  do |record,attr_name,value|
        record.errors.add attr_name, "has to be a student (#{record.class})" unless  value.is_a?(Student)
        record.errors.add attr_name, "invalid" unless record.created_by == value || record.student == value || created_by.admin?
      end

      ##########
      validates_each :confirmed_at, :on => :create do |record,attr_name,value|
        record.errors.add attr_name, "you cannot create a confirmed subscription" unless value.nil?
      end

      validates_each :os, :if => proc { |r| r.scheduled_course.is_a?(ScheduledCourse) }, :allow_blank => true do |record,attr,value|
        os = record.scheduled_course.os 
        record.errors.add attr, "(%s) not a valid OS (%s)" % [value, os || site(:os).join(', ')] unless 
        os ? os == value : site(:os).include?(value)
      end

      validates :retake, :allow_blank => true, :associated => { :message => "failed" }

      end
#    end

  end
end
