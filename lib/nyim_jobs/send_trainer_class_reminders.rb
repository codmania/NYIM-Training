class NyimJobs::SendTrainerClassReminders < NyimJobs::Base

  self.description =  "sending class reminders to teachers"
  def perform
    if Site.site(:notify_before_course_starts)
      in_batches ScheduledCourse.tomorrow do |course|
        Mailers::UserMailer.trainer_class_reminder({},{ :user => course.teacher, :scheduled_course => course })
      end
    end
  end
end
