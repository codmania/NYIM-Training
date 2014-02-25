class Views::Assets::List < Application::Widgets::Index
  #needs :display_options => nil, :search_options => Signup.search
  def widget_content
    h1 h1title
    link_to 'New Asset', new_asset_path
    search_and_display_form #if admin?
    super
  end

  def h1title
    'Assets'
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm do |f|
      f.inputs do
        f.input :name_contains, :label => 'Name contains', :required => false, :input_html => { :class => 'focus' }
        f.object.format_in=Asset::FORMATS.map(&:to_s) unless f.object.format_in && f.object.format_in.all?(&:blank?)
        f.input :format_in, :label => 'Format', :as => :check_boxes, :collection => Asset::FORMATS, :required => false, :wrapper_html => { :class => 'multi-column-list' }
      end
    end
  end

end
