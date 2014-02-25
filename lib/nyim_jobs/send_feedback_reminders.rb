class NyimJobs::SendFeedbackReminders < NyimJobs::Base

  self.description =  "sending feedback reminders"
  def perform
    if Site.site(:notify_when_course_ends)
      in_batches Signup.past.confirmed.attendance do |signup|
        Mailers::UserMailer.course_ends({},{ :student => signup.student, :signup => signup })
      end
    end
  end
end

