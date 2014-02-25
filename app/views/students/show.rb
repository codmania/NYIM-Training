class Views::Students::Show < Application::Widget
  
  def widget_content 
    heading ['Students', students_path], resource.full_name
    widget Application::Widgets::Show
  end
  
end