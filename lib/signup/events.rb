module Signup::Events
  class ::StateMachine::Event
    def guard(*conditions)
      proc { |record| conditions.all? { |condition| record.send condition } }
    end
  end

  def self.included( recipient )

    recipient.class_eval do

    #attr_protected :state_event

      state_machine :status, :initial => :pending do

        state :waiting
        state :pending
        state :deleted
        state :canceled
        state :released
        state :checked_out
        state :confirmed
        state :completed
        state :rescheduled
        state :awarded

        event :save_for_later do
          transition :checked_out => :waiting, :pending => :waiting, :if => guard(:attendance?)
        end
        after_transition :checked_out => :waiting, :do => [:release_seats, :recently_waiting!]

        event :forget do
          transition :pending => :deleted, :waiting => :deleted
          transition :checked_out => :deleted # :FIXME:
        end
        after_transition :on => :forget, :do => [:reconfirm_parent,:destroy]

        # if this is done by amdin, but student added themselves to waiting list
        # then the item will only appear in the students shopping cart not the admins
        # otherwise just signup student as admin and cancel or ignore the waiting list addition
        event :sign_up do
          transition :waiting => :pending, :if => guard(:future?,:not_full_or_cancelation?,:course_can_be_booked?,:class_can_be_booked?)
        end
        # we allow implicit transitioning by creating a pending signup and deleting waiting sisters

        event :check_out do
          transition :pending => :checked_out, :if => guard(:future?,:not_full_or_cancelation?)
        end
        before_transition :on => :check_out, :unless => :cancelation?, :do => [:reserve_seats]

        # this is applied to all purchases once payment is successful
        # unreserve parent seats for rescheduling
        event :succeed do
          transition :checked_out => :confirmed
        end
        after_transition :on => :succeed, :do => [:release_parent, :recently_confirmed!, :forget_waiting_sister]

        event :reconfirm do
          transition :canceled => :confirmed
        end
        after_transition :on => :reconfirm, :do => [:forget_child, :recently_confirmed!]

        event :suspend do
          transition :checked_out => :pending
        end
        after_transition :on => :suspend, :do => [:delete_transaction_code,:release_seats]

        # pending or reserved
        event :release do
          transition :canceled => :released
        end
        after_transition :on => :release, :do => [:release_seats]

        event :cancel do
          transition :confirmed => :canceled, :if => guard(:can_be_canceled?,:build_alternative)
        end
        after_transition :on => :cancel, :do => [:save_retake,:release_if_early_cancelation]

        event :complete do
          transition :confirmed => :completed, :if => :has_feedback?
        end
        after_transition :on => :complete, :do => [:recently_completed!]

        event :award do
          transition :completed => :awarded
        end
      end

    end
  end
end
