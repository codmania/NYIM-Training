class Views::Feedbacks::Show < Application::Widgets::List
  def widget_content
    h1 'View Feedback Detail'
    widget Views::Feedbacks::Item
  end
end
