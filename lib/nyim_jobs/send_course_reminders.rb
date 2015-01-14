class NyimJobs::SendCourseReminders < NyimJobs::Base

  self.description =  "sending course reminders"
  def perform
    if Site.site(:notify_before_course_starts)
      in_batches ScheduledCourse.tomorrow do |course|
        course.attendants.each do |student|
          Mailers::UserMailer.course_reminder({},{ :student => student, :course => course }) #if student.course_reminder_required?
        end
      end
    end
  end
end
