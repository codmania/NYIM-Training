class Ability

  include CanCan::Ability

  def initialize(user, local)

    alias_action :select, :to => :read
    alias_action :login, :to => :create
    alias_action :promotions, :to => :read
    alias_action :check, :to => :read
    alias_action :check_update, :to => :update
    alias_action :autocomplete, :to => :read

    can :asset, Asset
    can :index, Testimonial


    case user

      when Admin then
        can :manage, :all

      when Teacher then
        can :update, Teacher, :id => user.id
        can :read, Teacher
        can :read, [CourseGroup, Course, ScheduledCourse, ScheduledSession, Location]
        can :read, [User, Student, Company]
        can :update, Feedback, :scheduled_course_id => user.scheduled_course_ids
        can :read, Feedback, :scheduled_course_id => user.scheduled_course_ids
        can :list, Feedback, :scheduled_course_id => user.scheduled_course_ids
        can :destroy, :session
        can :create, :session

      when Student then
        can :create, Signup
        can :autocomplete, Company
        can :index, Company
        can :create, Student
        can :create, :session
        can :manage, Signup, :submitter_id => user.id
        can :manage, Signup, :created_by_id => user.id
        can :manage, Signup, :student_id => user.id
        can :shopping_cart, Signup
        can :read, [CourseGroup, Course, ScheduledCourse, ScheduledSession], :active => true
        cannot :show, ScheduledCourse
        can :destroy, :session
        can :manage, Student, :created_by_id => user.id
        can :manage, Student, :id => user.id
        can :create, Payment
        # submitting the feedback is via signup put
        can :read, Teacher
        can :index, Location
        can :show, Location

      else #when not logged in

           #can :auto_complete_for_company_name, Company
        can :autocomplete, Company
        can :index, Company
        can :index, Teacher
        can :show, Teacher
        can :index, Location
        can :show, Location
        can :create, :session
        can :manage, :devise_password_reset
        can :create, Student
        can :read, [CourseGroup, Course, ScheduledCourse, ScheduledSession], :active => true
        cannot :show, ScheduledCourse
        can :create, Signup
        can :launch, Job if local # to launch a Job from cron
        can :manage, :forget_passwords

    end
  end

end
