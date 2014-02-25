class Views::Assets::New < Application::Widgets::New
  def widget_content
    heading ["Assets", assets_path()], (resource.name.blank? ? 'New' : resource.name)
    super

  end
end