class Views::Sessions::New < Erector::Widget
  
  def content
    
      div :class => 'screen' do
        a :href => root_path do
          span :id => 'close' do
            text 'X'
          end
        end
        h1 'Log In:'
        div :id => 'form' do
          #text resource.inspect
          form_for resource, :url => user_session_path, :method => :post, :remote => true do |f|
            p do
              label :for => 'username' do
                text 'email:   '
              end
              input :type => 'text', :name => 'user[email]', :id => 'username', :value => resource.email
            end
            p do
              label :for => 'password' do
                text 'password:'
              end
              input :type => 'password', :name => 'user[password]', :id => 'password'
            end
            p do
              input :name => 'send', :type => 'submit', :class => 'loginbutton', :id => 'send', :value => 'Log In'
            end
          end
          div :id => 'key' do
            img :src => '/images/key.png', :width => '18', :height => '38'
          end
        end
        br
        p do
          link_to "Sign up", new_student_path()
          #new_registration_path(resource_name)
          br
          link_to "Forgot your password?", new_password_path(resource_name)
        end
      end
    #end

  end

end
