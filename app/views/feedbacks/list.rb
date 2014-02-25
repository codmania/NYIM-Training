class Views::Feedbacks::List < Application::Widgets::Index
  def widget_content
    h1 'Student Feedback'
    search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm do |f|
      div :class => 'accordion' do
        h3 { link_to "date", '#', :remote => false }
        div do
          f.inputs do
            f.input :created_at_greater_than,
                    :as         => :string, :required => false, :label => 'From',
                    :input_html => { 'data-datepicker' => '' }
            f.input :created_at_less_than,
                    :as         => :string, :required => false, :label => 'To',
                    :input_html => { 'data-datepicker' => '' }
          end
        end
        h3 { link_to "status", '#', :remote => false }
        div do
          f.inputs do
            f.object.read_in ||= [true, false]
            f.input :read_in, :label => 'Read',
                    :as              => :check_boxes,
                    :collection      => boolean_collection,
                    :member_label    => proc { |x| yesno(x) },
                    :required        => false
            f.object.display_in ||= [true, false]
            f.input :display_in, :label => 'To display',
                    :as                 => :check_boxes,
                    :collection         => boolean_collection,
                    :member_label       => proc { |x| yesno(x) },
                    :required           => false
          end
        end
        h3 { link_to "users", '#', :remote => false }
        div do
          f.inputs do
            f.input :student_full_name_with_email,
                    :as       => :autocomplete,
                    :label    => 'Student',
                    :required => false,
                    :hint     => 'Start typing to get autocompletion',
                    :url      => autocomplete_students_path
          end
        end
      end
    end
  end

end
