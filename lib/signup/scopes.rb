module Signup::Scopes
  def self.included(base)
    base.class_eval do

      scope :attendance, lambda { |*a| where :purchase_type.eq => true }
      scope :cancelation, lambda { |*a| where :purchase_type.in => [nil, false] }

      def self.states
        self.state_machines[:status].states.map &:name
      end

      def self.define_state_scopes
        states.each do |state|
          scope state, lambda { |*a| where(:status.eq => state.to_s) } unless respond_to? state
        end
      end

      def sisters
        self.class.sisters(self)
      end

      def cousins
        self.class.cousins(self)
      end

      def relatives
        self.class.relatives(self)
      end

      scope :cousins, lambda { |base|
        where(:course_id.eq => base.course_id, :student_id.eq => base.student_id, :scheduled_course_id.not_eq => base.scheduled_course_id, :id.not_eq => base.id)
      }

      scope :sisters, lambda { |base|
        where(:scheduled_course_id.eq => base.scheduled_course_id, :student_id.eq => base.student_id, :id.not_eq => base.id)
      }

      scope :relatives, lambda { |base|
        where(:course_id.eq => base.course_id, :student_id.eq => base.student_id, :id.not_eq => base.id)
      }

      scope :shopping_cart, lambda { |u|
        upcoming.where(:status.in => ['pending', 'checked_out']).where({ :created_by_id.eq => u } | { :submitter_id.eq => u } | { :student_id.eq => u })
      }

      scope :completed_or_awarded, lambda { |*a|
        where(:status.in => ['completed', 'awarded'])
      }

      scope :past, lambda { |*a|
        joins(:scheduled_course).where :scheduled_course => { :ends_at.lt => Time.now }
      }

      scope :upcoming, lambda { |*a|
        joins(:scheduled_course).where :scheduled_course => { :starts_at.gt => Time.now }
      }

      scope :current, lambda { |*a|
        joins(:scheduled_course).where :scheduled_course => { :ends_at.gt => Time.now }
      }

      scope :running, lambda { |*a|
        current.joins(:scheduled_course).where :scheduled_course => { :starts_at.lt => Time.now }
      }

      scope :confirmed, lambda { |*a|
        where :status.eq => 'confirmed'
      }

      scope :completed, lambda { |*a|
        past.attendance.where :status.eq => 'completed'
      }

      scope :waiting, lambda { |*a|
        upcoming.attendance.where :status.eq => 'waiting'
      }

      scope :certificates_to_be_mailed, lambda { |*a|
        # this retrieves those confirmed subscriptions for which the class has ended and
        # a certificate is yet to be mailed to the person
        completed.where :certificate_mailed_on.eq => nil
      }
    end
  end
end
