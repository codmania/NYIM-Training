class Views::Locations::List < Application::Widgets::Index
  def widget_content
    h1 'Locations'
    #search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm
  end

end
