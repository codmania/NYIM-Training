class NyimJobs::SendFeedbackReminders < NyimJobs::Base

  self.description =  "sending feedback reminders"
  def perform
    if Site.site(:notify_when_course_ends)
      in_batches Signup.confirmed.attendance.inthelasthour.reject(&:blank?) do |signup|
        Mailers::UserMailer.course_ends({},{ :student => signup.student, :signup => signup })
      end
    end
  end
end
