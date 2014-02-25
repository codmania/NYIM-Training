class Views::Site::StudentSidebar < Application::Widget

  needs :user
  def content
    #

    self.user = current_student || current_user # assigns nil if admin no session
    div :id => 'student_sidebar' do
      if user.is_a? Student
        ul :class => 'links' do
          li :class => "rounded-corners-shadow" do
            link_to edit_student_path(user) do
              span 'Edit profile'
            end
          end
          li :class => "rounded-corners-shadow" do
            link_to 'View profile', student_path(user)
          end if admin?
        end

        shopping_cart(user)
        #
        classes = user.signups.confirmed.attendance
        h1 'Current Classes'
        classes.each { |course| current_class course }

        classes = user.signups.completed_or_awarded
        h1 'Completed Classes'
        classes.each { |course| completed_class course }

        classes = user.signups.waiting
        h1 'Waiting Classes'
        classes.each { |course| waiting_class course }

        widget Views::Site::Promotions unless admin?
      end
    end

  end

  def shopping_cart(user)
    div :id => dom_id(user,'cart'), :class => 'cart' do
      classes = Signup.shopping_cart(user)
      link_to shopping_cart_path(user) do
        span do
          p "#{user.full_name_with_email}" if admin?
          p "Checkout #{pluralize(classes.count,'item')}"
        end
      end
      ul do
        classes.each do |signup|
          li :id => dom_id(signup,:shopping_cart_item) do
            div :class => "rounded-corners-shadow"  do
              link_to admin? ? signup_path(signup) : course_path(signup.course) do #signup_path(signup)
                span do
                    text signup.name, ' '
                    text signup.student.name unless signup.student == current_user
                  br
                  text signup.scheduled_course.to_menu
                end
              end
            end
            div :class => "rounded-corners-shadow forget" do
              button_to 'x', forget_signup_path(signup), :method => :put
            end
          end
        end
      end
      div ' '
    end
  end

  def completed_class(signup)
    div :class => 'sidebar_class' do
      h2 signup.full_name
      p do
        ul :class => 'links' do
          li { link_to 'Outline', course_path(signup.course) }
          li { link_to 'Resources', display_asset_path(signup.course.resources_asset_name) }
          li { link_to 'Certificate', certificate_signup_path(signup) }
        end
      end
    end
  end

  def current_class(signup)
    div :class => 'sidebar_class' do
      h2 signup.full_name
      p do
        ul :class => 'links' do
          li { link_to 'Outline', course_path(signup.course) }
          if signup.not_too_late?
            li { link_to 'Reschedule', reschedule_signup_path(signup) }
            li { button_to 'Cancel', reschedule_update_signup_path(signup), :method => :put }
          elsif !signup.past?
            li { link_to 'Reschedule', reschedule_signup_path(signup) }
            li { link_to 'Cancel', reschedule_signup_path(signup) }
          end
          li { link_to 'Leave Feedback', feedback_signup_path(signup) } if signup.can_have_feedback?
        end
      end
    end
  end

  def waiting_class(signup)
    div :class => 'sidebar_class' do
      h2 signup.full_name
      p do
        ul :class => 'links' do
          li button_to 'Signup', add_to_shopping_cart_signup_path(signup), :method => :put if signup.not_full?
          li button_to 'Forget', forget_signup_path(signup), :method => :put
        end
      end
    end
  end
end
