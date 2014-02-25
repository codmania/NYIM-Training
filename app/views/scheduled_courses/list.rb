class Views::ScheduledCourses::List < Application::Widgets::Index
  def widget_content
    h1 'Scheduled Courses'
    search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    widget Views::Site::SearchAndDisplayForm do |f|
      f.inputs do
        f.input :course_name_contains, :label => 'Name contains', :required => false
        f.input :starts_at_greater_than, :as => :string, :required => false, :label => 'Starts after',
                :input_html => {'data-datepicker' => ''}
        f.input :starts_at_less_than, :as => :string, :required => false, :label => 'Starts before',
                :input_html => {'data-datepicker' => ''}
        f.input :created_at_greater_than, :as => :string, :required => false, :label => 'Created after',
                :input_html => {'data-datepicker' => ''}
        f.input :created_at_less_than, :as => :string, :required => false, :label => 'Created before',
                :input_html => {'data-datepicker' => ''}

      end
    end
  end
end