class Views::Signups::Create < Views::Signups::New
  include Application::Widgets::Extensions
  
  def widget_content
    unless resource.new_record?
      if resource.waiting?
        div :id => 'success', :class => 'box_striped' do
          text "You have been added to the waiting list for #{course} staring on #{date}. "
        end
      else
        rawtext asset 'signup'
        controller.redirect_to shopping_cart_path(current_user.slug)
      end
      self.record = Signup.new(:course => resource.course, :scheduled_course => resource.scheduled_course, :os => resource.os)
      
      
    else
      @submitted = true
    end

    super
  end

end
