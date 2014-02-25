class Views::Users::Show < Application::Widget
  
  def widget_content 
    heading ['Users', users_path], resource.full_name
    widget Application::Widgets::Show
  end
  
end