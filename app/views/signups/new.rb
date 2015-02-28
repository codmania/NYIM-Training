class Views::Signups::New < Application::Widgets::New
  def widget_content
    h1 'Sign Up'
    super
    div :id => :selected_class do
      if resource.respond_to? :scheduled_course
        course = resource.scheduled_course
        widget(Views::ScheduledCourses::Select, :course => course) if course
      end
    end
  end

  def signup_form_content(form, w)
    form.semantic_errors
    signup = form.object
    errors(signup)
    form.inputs do
      form.input :course, :collection => Course.active, :include_blank => 'Choose Class',
                 :input_html          => { 'data-observe-url' => select_course_url('%(selected)', :format => :js) }
      form.input :scheduled_course, :collection => scheduled_courses_dropdown(signup.course, :tag => false), :include_blank => false,
                 :input_html                    => { 'data-observe-url' => select_scheduled_course_url('%(selected)', :format => :js) }, :hint => 'Hint: e.g. (3/10) shows 3 free seats of a 10 student class'
      form.input :os, :as => :select, :collection => os_dropdown(signup.course, :tag => false), :include_blank => 'Choose operating system'
      form.input :allow_double_booking, :as => :boolean, :label => 'Confirm you want to rebook this course' unless signup.double_booking.nil? || signup.double_booking.empty?
      # admin and those already managing students can search by autocomplete
      can_select_students  = admin? || user_signed_in? && !current_user.students.empty?
      # new student for is by default if not logged in or admin or if new student was previously selected
      new_student_selected = !user_signed_in? || !params[:student].blank?
      if user_signed_in?
        li do
          label 'Student'
          choice_text = can_select_students ? 'Existing Student' : 'Yourself'
          select_tag 'student', options_for_select([[choice_text, ''], ['New Student', 'true']], new_student_selected||''),
                     'data-select-target' => 'true',
                     'data-select-show'   => '#new_student_form',
                     'data-select-clear'  => "#signup_student_email",
                     'data-select-hide'   => '#signup_student_email_input',
                     'data-select-write'  => "#signup_student_attributes_mandatory"
        end
        form.object.student_email = default_student.full_name_with_email if default_student
        form.input :student_email,
                   :as           => :autocomplete,
                   :label        => 'Existing Student',
                   :hint => 'Start typing to get autocompletion',
                   :url          => autocomplete_students_path,
                   :wrapper_html => { :style => ('display:none;' if new_student_selected) } if can_select_students
      end

      new_student_mandatory = !user_signed_in? || !params[:student].blank?
      unless signup.student && signup.student.new_record?
        signup.build_student(:mandatory => new_student_selected)
        signup.student.phone_numbers.build
        submitter = student? ? current_user : signup.submitter


        signup.student.company ||= submitter.company if submitter
      end
      div :id => 'new_student_form', :style => ('display:none;' unless new_student_selected) do
        form.semantic_fields_for :student do |student_form|
          student_fields(student_form, w, 'New Student', 'signup_student_attributes')
        end
      end
    end
    formtastic_button(form, 'Sign Up')
  end


  def checkout_button
    button_to(shopping_cart_path(resource.submitter),
              :method => :get,
              :class  => "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only",
              :role   => "button") do
      span :class => "ui-button-text" do
        text 'Proceed to Checkout'
      end
    end
  end

end
