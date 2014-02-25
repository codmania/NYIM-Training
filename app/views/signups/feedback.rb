class Views::Signups::Feedback < Application::Widgets::New
  def widget_content
    h1 'Leave Feedback'
    if admin? || resource.can_have_feedback?
      self.content_method = :leave_feedback_form_content
      self.form_options   = { :url => feedback_update_signup_path(resource), :method => :put }
      super
    else
      text 'you cannot leave feedback to this class'
    end
  end

  def leave_feedback_form_content(form, w)
    form.semantic_errors
    signup = form.object
    errors(signup)
    form.inputs do
      signup.build_feedback(:scheduled_course_id => signup.scheduled_course_id) unless signup.feedback
      signup.feedback.scheduled_course.errors
      form.semantic_fields_for :feedback do |feedback|
        feedback.input :scheduled_course_id, :as => :hidden
        feedback_form_content(feedback, self)
      end
    end
    formtastic_button(form, 'Submit Feedback')
  end

end
