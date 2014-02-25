module ScheduledCourse::Validations
  def self.included(base)
    base.class_eval do
      validates_presence_of :scheduled_sessions, :message => 'at least one session has to be scheduled'
      #  #validates_numericality_of :price_in_usd, :allow_nil => true
      #  # ok since price is important, let's be VERY restrictive about the format
      #  # 0.01 ok .01 NOT ok 1.000 not ok 1,000 ok 13,000 ok 13,00 NOT ok 13000,000 OK! 1,300.00 ok
      #  validates_format_of :price_in_usd, :allow_blank => true, :with => /\A[0-9]+(,?[0-9][0-9][0-9])*(\.[0-9][0-9])?\Z/

      validates :teacher, :course, :location, :existence => true

      validates_each :seats_available, :on => :update do |record,attr,value|
        record.errors.add attr, "should be between 0..#{record.seats}" unless value && value <= record.seats && value >= 0
      end
      validates_each :seats_available, :on => :create do |record,attr,value|
        record.errors.add attr, "should be #{record.seats}" unless value && value == record.seats
      end

      validates :seats, :numericality => { :integer_only => true }
      validates :hours, :numericality => true, :allow_blank => true

      validates :scheduled_sessions, :associated => true
      #validates :price_in_usd, :allow_blank => true, :format => { :with => /\A[0-9]+(,?[0-9][0-9][0-9])*(\.[0-9][0-9])?\Z/ }

      validates_each :os, :if => proc { |r| r.course.is_a?(Course) }, :allow_blank => true do |record,attr,value|
        os = record.course.os 
        record.errors.add attr, "not a valid OS (%s)" % os || site(:os).join(', ') unless os ? os == value : site(:os).include?(value)
      end
      
    end
  end

end
