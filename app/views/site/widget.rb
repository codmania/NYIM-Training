class Views::Site::Widget < Application::Widget
  
  #needs :widget_class
  def widget_content
    widget widget_class
  end
  
end