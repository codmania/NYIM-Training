class NyimJobs::SendTrainerClassReminders < NyimJobs::Base

  self.description =  "sending class reminders to teachers"
  def perform
    if Site.site(:notify_before_course_starts)
      ScheduledCourse.tomorrow.each do |course|
        Mailers::UserMailer.trainer_class_reminder({},{ :user => course.teacher, :course => course })
      end
    end
  end
end
