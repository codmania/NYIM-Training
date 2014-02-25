module Signup::StateMachineHooks
  def self.included(recipient)

    recipient.class_eval do
      #

      def delete_transaction_code
        self.transaction_code = nil
      end

      def can_have_feedback?
        confirmed? && past? && attendance?
      end

      def can_be_canceled?
        future? && attendance? && not_too_late?
      end

      # guard cancel
      def not_too_late?
        not_too_late  = scheduled_course.starts_at && scheduled_course.starts_at > Time.now.at_midnight.since(2.days)
        self.too_late = !not_too_late
        not_too_late
      end

      def early_change?
        scheduled_course.starts_at && scheduled_course.starts_at > Time.now.at_midnight.since(5.days)
      end

      # guard complete
      def has_feedback?
        feedback.is_a?(Feedback)
      end

      # guard sign_up/checkout
      def not_full_or_cancelation?
        not_full? || cancelation?
      end

      def time_out_if_still_checked_out(ref_checkout_time)
        #reload && # no bother if deleted since
        #checked_out? && # no bother if not checked out anymore
        #(checkout_time <= ref_checkout_time) && # no problem if checked out again
        if checked_out? && (checkout_time <= ref_checkout_time) then
          suspend! && save!
        end
      end

      def reconfirm_parent
        deleted? && parent && (parent.released? || parent.reconfirm) || true
      end

      def updated_by!
        if updated_by
          self.created_by = updated_by
          self.submitter  = updated_by
        end
        self
      end

      def delete_transaction_code
        self.transaction_code = nil
      end

      def build_cancelation
        self.class.new :course  => course, :scheduled_course => scheduled_course,
                       :student => student, :submitter => submitter, :created_by => created_by
      end

      def build_alternative
        if rescheduled_course_id.blank? # cancel
          if early_change?
            true
          else
            c               = build_cancelation
            c.purchase_type = false
            c.save
          end
        else
          # make sure no rel is checked out
          sisters.checked_out.each &:suspend
          self.retake                = sisters.pending.first || build_cancelation
          retake.purchase_type       = true # if class first canceled we still turn it into retake
          retake.scheduled_course_id = rescheduled_course_id
          retake.scheduled_course(true)
          retake.to_be_retake!
          true
        end
      end

      def release_if_early_cancelation
        release if early_change? && !retake
      end

      def save_retake
        return unless retake
        if early_change?
          retake.check_out && retake.succeed
        else
          retake.save
        end

      end

      def forget_waiting_sister
        sisters.waiting.each &:forget
      end

      def forget_child
        relatives.checked_out.each &:suspend
        relatives.pending.each &:forget!
      end

      def release_seats
        # on failure, the seat is released if retake or confirmation
        scheduled_course.unreserve! if !cancelation?
      end

      def cancelation?
        #sisters && sisters.canceled?
        purchase_type == false
      end

      def retake?
        purchase_type == true && parent && true
        #sisters && sisters.rescheduled?
      end

      def to_be_retake!
        @to_be_retake = true
      end

      def to_be_retake?
        @to_be_retake
      end

      def attendance?
        # includes retakes!!!
        #!cancelation? && !failed?
        purchase_type == true
      end

      def release_parent
        # if this is a cancelation , then on success unreserve the seat
        # the idea is that on failure the seat is not released
        # if you dont pay for cancelation then you have the right for the seat
        # same with retake
        parent && parent.release
      end

      def reserve_seats
        scheduled_course.reload.reserve!
      end

      def parent
        relatives.canceled.first || relatives.released.first
      end

    end
  end
end
