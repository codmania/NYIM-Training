class Views::Signups::Reschedule < Application::Widgets::New
  def widget_content
    h1 'Reschedule'
    if resource.can_be_canceled? || resource.can_reconfirm?
      self.content_method = :reschedule_form_content
      self.form_options   = { :url => reschedule_update_signup_path(resource), :method => :put }
      super
      div :id => :selected_class, :class => 'rounded-corners-shadow' do
        course = resource.scheduled_course
        widget(Views::ScheduledCourses::Select, :course => course) if course
      end
    else
      text 'you cannot cancel or reschedule this class. See our '
      link_to 'Policies', display_asset_path('Policies')
    end
  end

  def reschedule_form_content(form, w)
    form.semantic_errors
    signup = form.object
    errors(signup)
    form.inputs do
      form.input :rescheduled_course_id,
                 :as            => :select,
                 :label         => 'Reschedule to',
                 :collection    => signup_scheduled_courses_dropdown(signup, :tag => false),
                 :include_blank => false,
                 :hint          => 'Choose an alternative date or cancel',
                 :input_html    => { 'data-observe-url' => select_scheduled_course_url('%(selected)', :format => :js) }
      form.input :os, :as => :select, :collection => os_dropdown(signup.course, :tag => false), :include_blank => 'Choose operating system'

    end
    formtastic_button(form, 'Reschedule')
  end

end
