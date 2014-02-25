class Views::Courses::List < Application::Widgets::Index
  
  def widget_content
    h1 'Courses'
    search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm do |f|
      f.inputs do
        f.input :name_contains, :label => 'Name contains', :required => false
      end
    end
  end
end