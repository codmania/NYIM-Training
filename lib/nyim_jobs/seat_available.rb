class NyimJobs::SeatAvailable < NyimJobs::Base

  self.description =  "notify that seat is available"
  def initialize(init)
    super(init)
    @course_id = options[:course].ifnil?(&:id) || raise(ArgumentError,"no course given")
  end

  def perform
    course = ScheduledCourse.find_by_id(@course_id)
    course && !course.full? or return
    in_batches(course.signups.waiting) do |signup|
      Mailers::UserMailer.seat_available({},{ :student => signup.student, :signup => signup }).deliver
    end
  end
end

