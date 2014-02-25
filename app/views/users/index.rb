class Views::Users::Index < Application::Widget
  
  def widget_content
    h1 'Users'
    widget Application::Widgets::Index
  end
  
end
