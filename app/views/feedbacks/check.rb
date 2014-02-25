class Views::Feedbacks::Check < Application::Widgets::List

  def widget_content
    h1 'Check New Feedback'
    self.info = nil
    super
  end

  def item(f)
    widget Views::Feedbacks::Item, :resource => f
  end
end
