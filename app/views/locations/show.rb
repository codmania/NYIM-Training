class Views::Locations::Show < Application::Widget
  def widget_content
    rawtext asset(resource.directions_asset_name)
  end
end
