class Views::Testimonials::Manage < Application::Widgets::List

  def widget_content
    h1 'Manage Legacy Testimonials'
    super
  end

  def item(testimonial)
    widget Application::Widgets::New, :record => testimonial, :form_options => { :url => { :id => testimonial.id, :action => :manage_update } }
  end
end