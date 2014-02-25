module Signup::Notifications
  def self.included( recipient )

    recipient.class_eval do
      def assigns
        { :signup => self, :student => student, :course => scheduled_course }
      end

      def recently_completed!
        NyimJobs::DelayedUserMailer.certificate({}, assigns) if site(:notify_when_certificate_available)
        award
      end

      def recently_confirmed!
        #return true if Rails.env.test?
        if attendance?
          NyimJobs::DelayedUserMailer.course_confirmation({},assigns) if site(:notify_when_course_confirmed)
        else
          NyimJobs::DelayedUserMailer.course_cancelation({},assigns) if site(:notify_when_course_confirmed)
          NyimJobs::DelayedUserMailer.course_cancelation_admin({},assigns.merge(:user => Admin.first))
        end
        true
      end

      def recently_waiting!
        NyimJobs::DelayedUserMailer.waiting_list_confirmation({},assigns) if site(:notify_when_course_confirmed)
        true
      end

    end
  end

end
