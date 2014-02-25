class Views::Site::UserPanel < Application::Widget
  def content
    if signed_in?
      div :class => 'sidebar1', :id => 'sidebar' do
        span :class => 'highlight' do
          text "logged in as #{current_user.email}"
          if student? && (current_user.discount || 0) > 0
            br
            text "#{current_user.discount}% discount"
          end
        end

        if admin?
          div :id => dom_id(current_user, 'cart'), :class => 'cart' do
            max_items = 3
            classes   = Signup.shopping_cart(current_user)
            count     = classes.count
            count = "#{max_items}/#{count}" if count > 3
            count =
                link_to shopping_cart_path(current_user) do
                  span do
                    p "Admin cart"
                    p "#{count} items"
                  end
                end
            ul do
              classes.limit(3).each do |signup|
                li :id => dom_id(signup, :shopping_cart_item) do
                  div :class => "rounded-corners-shadow" do
                    link_to signup_path(signup) do #
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
          #h2 link_to 'Admin panel', sidebar_students_path(:student => "")
          div do
            widget Views::Site::AdminMenu
          end
          h2 'Student Panel'
          form_tag sidebar_students_path, :method => :get, :remote => true do
            rawtext autocomplete_field_tag 'student', '', autocomplete_students_path
            br :class => 'item_spacer'
            submit_tag 'Search', 'data-button' => true
            submit_tag 'Back to Admin', 'data-button' => true
          end
        elsif student? && current_user.children.count > 0
          h2 'Student Panel'
          form_tag sidebar_students_path, :method => :get, :remote => true do
            rawtext autocomplete_field_tag 'student', '', autocomplete_students_path
            br :class => 'item_spacer'
            submit_tag 'Search', 'data-button' => true
            submit_tag 'Back to Self', 'data-button' => true
          end
        end

        unless teacher?
          widget Views::Site::StudentSidebar, :user => current_user
        else
          p do
            text 'Teacher sidebar'
            div do
              img :src => current_user.photo.url, :alt => current_user.name, :width => '155', :height => '155', :class => 'fltl-left-rounded-corners-shadow'
            end
            br :class => "item_spacer"
            ul :class => 'links' do
              li :class => "rounded-corners-shadow" do
                link_to 'Edit profile', edit_trainer_path(current_user)
              end
              li :class => "rounded-corners-shadow" do
                link_to 'View profile', trainer_path(current_user)
              end
              li :class => "rounded-corners-shadow" do
                link_to 'Check New Feedback', check_feedbacks_path()
              end
              li :class => "rounded-corners-shadow" do
                link_to 'Browse Feedback', list_feedbacks_path()
              end
            end
          end
        end
      end
    else
      widget Views::Site::NyimRight
    end
  end

end

