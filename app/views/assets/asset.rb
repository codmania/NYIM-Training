class Views::Assets::Asset < Application::Widget

  needs :resource => nil, :fallback => nil

  def widget_content
    @resource ||= resource
    rawtext asset(@resource,@fallback)
  end

end