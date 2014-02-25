class Views::Companies::List < Application::Widgets::Index
  def widget_content
    h1 'Client Companies'
    search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm do |f|
      f.inputs do
        f.input :name_contains, :label => 'Name contains', :required => false
        f.object.featured_in ||= [true, false]
        f.input :featured_in, :label => 'Featured', :as => :check_boxes, :collection => boolean_collection,
                :member_label        => proc { |x| yesno(x) }, :required => false
      end
    end
  end
end