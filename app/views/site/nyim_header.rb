# coding: utf-8
class Views::Site::NyimHeader < Erector::Widget
  def content
    div :class => 'header', :id => 'header' do

      div :id => 'topbar' do
        a :href => "mailto:#{site(:email)}" do
          img :src => '/images/mail.png', :alt => 'email', :width => '50', :height => '37', :class => 'fltrt'
        end
        div :class => 'fltlft', :id => 'logo' do
          a :href => root_path do
            img :src => '/images/nyimlogo.png', :width => '39', :height => '37', :alt => 'Training-NYC logo'
          end
        end
        div :id => "fade_base" do
          a :id => "fade_link"
        end
        p do
          text '1 Union Square West, Suite 805, NY, NY • Information and Booking: 212.658.1918'
        end
      end

      div :id => 'classes' do
        div :id => 'button_left' do
          link_to 'Sign Up', new_signup_path
        end
        widget Views::Site::CourseMenu
      end

      div :id => 'info' do
        div :id => 'button_left' do
          if signed_in?
            link_to "Log Out", destroy_user_session_path, :method => :get
          else
            link_to "Log In", new_user_session_path #, :remote => true
          end
        end
        widget Views::Site::MainMenu
      end
    end

  end

end