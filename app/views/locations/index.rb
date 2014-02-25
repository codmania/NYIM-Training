class Views::Locations::Index < Application::Widgets::Index
  #needs :display_options => nil, :search_options => Signup.search
  def widget_content
    if resource.empty?
      h1 'No venue set. '
      link_to 'Set one up', new_location_path() if admin?
    else
      if resource.length == 1
        rawtext asset(resource.first.directions_asset_name)
      else
        h1 'Locations'
        ul :class => :links do
          resource.each do |location|
            li :class => "rounded-corners-shadow" do
              link_to location.to_s, location_path(location)
            end
          end
        end
      end

    end
  end

end