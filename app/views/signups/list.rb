class Views::Signups::List < Application::Widgets::Index
  #needs :display_options => nil, :search_options => Signup.search
  def widget_content
    h1 'Signups'
    search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm do |f|

      h3 { link_to "date", '#', :remote => false }
      div do
        f.inputs do
          f.input :created_at_greater_than, :as => :string, :required => false, :label => 'From',
                  :input_html                   => { 'data-datepicker' => '' }
          f.input :created_at_less_than, :as => :string, :required => false, :label => 'To',
                  :input_html                => { 'data-datepicker' => '' }
        end
      end
      h3 { link_to "status", '#', :remote => false }
      div do
        #search_options.status_in ||= Signup.states
        f.object.status_in=Signup.states.map(&:to_s) unless f.object.status_in #&& f.object.status_in.all?(&:blank?)
        f.inputs :class => 'multi-column-list' do
          f.input :status_in, :label => 'Status', :required => false, :as => :check_boxes,
                  :collection        => Signup.states.map(&:to_s), :include_blank => false #, :wrapper_html => { :class => 'multi-column-list' }
        end
      end
      h3 { link_to "users", '#', :remote => false }
      div do
        f.inputs do
          f.input :student_email_equals,
                  :as    => :autocomplete,
                  :label => 'Student', :required => false,
                  :hint  => 'Start typing to get autocompletion', :url => autocomplete_users_path
        end
      end

    end
  end
end