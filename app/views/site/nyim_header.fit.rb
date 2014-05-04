# coding: utf-8
class Views::Site::NyimHeader < Erector::Widget
  
  def content 
    
    div :id => 'header' do
      div :class => 'shadow-shine', :id => 'topbar' do
        div :id => 'logo' do
        end
        div :id => 'address' do
          text '1 Union Square West, Suite 903, NY, NY • Information and Booking: 212.658.1918'
        end
        div :id => 'mail' do
          a :href => 'mailto:faye@training-nyc.com?Subject=WebMail' do
            img :src => '/images/mail.png', :width => '50', :height => '37', :alt => 'Email'
          end
        end
      end
      div :id => 'menu1' do
        div :class => 'rounded-corners-shadow', :id => 'classbutton' do
          text 'Find Classes:'
        end
        div :class => 'rounded-corners-shadow', :id => 'classes' do
          widget Views::Site::CourseMenu
        end
        div :class => 'rounded-corners-shadow', :id => 'signup' do
          link_to 'Sign Up', new_signup_path
        end
      end
      
      div :id => 'menu2' do
        div :class => 'rounded-corners-shadow', :id => 'infobutton' do
          text 'Information:'
        end
        
        div :class => 'rounded-corners-shadow', :id => 'info' do
          widget Views::Site::MainMenu
        end
        div :class => 'rounded-corners-shadow', :id => 'login' do
          if user_signed_in?
            link_to "Log Out", destroy_user_session_path, :method => :get
          else
            link_to "Log In", new_user_session_path, :remote => true
          end
        end
      end
      rawtext '<!-- end #header -->'
    end
  end
  
end