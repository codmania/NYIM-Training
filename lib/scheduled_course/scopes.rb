module ScheduledCourse::Scopes
  def self.included(base)
    base.class_eval do

      default_scope :order => 'starts_at ASC'

      scope :by_course_name, lambda { |*names|
        joins(:course).where(:course => { :name.in => names })
      }

      scope :alternative, lambda { |*o|
        course = o[:course]
        future.where :course_id.eq => course.course_id, :id.not_eq => course.id
      }

      scope :tomorrow, lambda {
        s = Time.now.midnight + 1.day
        e = s + 1.day
        where(:starts_at.lt => e, :starts_at.gt => s)
      }

      scope :starts_no_later_than, lambda { |date|
        where(:starts_at.lt => date)
      }
      scope :ends_not_earlier_than, lambda { |date|
        where(:ends_at.gt => date)
      }

      scope :full, lambda { |*a|
        where :seats_available.lt => 1
      }

      scope :not_full, lambda { |*a|
        where :seats_available.gt => 0
      }

      scope :future, lambda { |*o|
        where(:starts_at.gt => Time.now)
      }

      scope :upcoming, lambda { |*o|
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
        # also maps to start time!
        where(:starts_at.lt => Time.at(o.first.to_i).to_formatted_s(:db))
      }

      scope :active, (lambda {
                        joins(:course, :course_group).where(:course_group => { :active.eq => true },
                                                            :course       => { :active.eq => true },
                                                            :active.eq    => true)
      })

      search_methods :calendar_from_dt, :calendar_to_dt #,  :splat_param => true, :type => [:integer]

    end
  end
end
