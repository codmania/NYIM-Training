class NyimJobs::SendFeedbackReminders < NyimJobs::Base

  self.description =  "course ends reminders"
  def perform
    if Site.site(:notify_when_course_ends)
      Signup.confirmed.attendance.inthelasthour.reject(&:blank?).each do |signup|
        Mailers::UserMailer.course_ends({},{ :student => signup.student, :signup => signup })
      end
    end
  end
end
