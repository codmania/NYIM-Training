class NyimJobs::SendCourseReminders < NyimJobs::Base

  self.description =  "sending course reminders"
  def perform
    if Site.site(:notify_before_course_starts)
      in_batches ScheduledCourse.future.starts_no_later_than(Site.site(:course_check_interval)) do |course|
        course.attending_students.each do |student|
          Mailers::UserMailer.course_reminder({},{ :student => student,:course => course }) #if student.course_reminder_required?
        end
      end
    end
  end
end