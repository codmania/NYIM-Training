class Views::Jobs::List < Application::Widgets::Index
  #needs :display_options => nil, :search_options => Signup.search
  def widget_content
    widget Views::Jobs::Tasks
    h1 'Background Processes'
    search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm do |f|
      f.inputs do
        f.input :description_contains, :label => 'Info contains', :required => false
      end
    end
  end
  
end