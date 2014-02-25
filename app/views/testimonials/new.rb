class Views::Testimonials::New < Application::Widgets::New

  def content
    heading ["Manage Testimonials", manage_testimonials_path], 'New'
    super
  end

end

