class Application::Widgets::Show < Application::Widget
  
  needs :show => nil
  
  def widget_content
    self.show ||=  controller.resource
    widget Application::Widgets::Index, 
    :info => false, :pagination => false, :collection => [show]
  end
  
end
