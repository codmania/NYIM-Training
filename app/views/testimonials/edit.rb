class Views::Testimonials::Edit < Application::Widgets::New
  def widget_content
    heading ["Manage Testimonials", manage_testimonials_path], 'Edit'
    super
  end
end
