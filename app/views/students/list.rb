class Views::Students::List < Application::Widgets::Index
  #needs :display_options => nil, :search_options => Signup.search
  def widget_content
    h1 'Students'
    search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm do |f|
      f.inputs do
        f.input :full_name_with_email,
                :as    => :autocomplete,
                :label => 'Name or Email', :required => false,
                :hint  => 'Start typing to get autocompletion', :url => autocomplete_students_path
        f.object.invoiceable_in ||= [true, false]
        f.input :invoiceable_in, :label => 'Invoiceable',
                :as                     => :check_boxes,
                :collection             => boolean_collection,
                :member_label           => proc { |x| yesno(x) },
                :required               => false
      end
    end
  end

end