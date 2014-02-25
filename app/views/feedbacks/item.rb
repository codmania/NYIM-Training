class Views::Feedbacks::Item < Application::Widget

  needs :resource => nil

  def widget_content
    f = self.resource
    div do
      if admin?
        widget ::Application::Widgets::Show#, :show => f
      else
        p do
          link_to f.student.abbreviated_name, student_path(f.student)
          text ' ('
          link_to f.student.company.name, company_path(f.student.company)
          text ') - '
          link_to f.scheduled_course.name, scheduled_course_path(f.scheduled_course)
          text ' - '
          link_to 'see signup', signup_path(f.signup), :disabled => !admin?
        end
        p :class => 'public' do
          text f.text
        end
        p :class => 'private' do
          text f.how_to_improve
        end
      end
      br
      p do
        action = admin? ? :update : :check_update
        semantic_form_for f, :url => { :id => f.id, :action => action } do |form|
          form.semantic_errors
          feedback_form_content(form, self) if admin?
          form.inputs do
            form.input :read, :input_html => { :checked => true } #, :as => :hidden
            form.input :display,
                       :hint => 'untick if you consider public review inappropriate to display as testimonial'
            form.object.comments.build(:user_id => current_user.id)
            h3 'Comments'
            form.semantic_fields_for :comments do |cform|
              comment = cform.object
              p do
                cform.inputs do
                  cform.input :user_id, :as => :hidden
                  if comment.new_record?
                    cform.input :text, :required => false, :input_html => { :size => '50x1' },
                                :label           => "New Comment"
                  elsif admin?
                    cform.input :text, :required => false, :input_html => { :size => '50x1' },
                                :label           => "#{comment.user.name} (on #{comment.updated_at.to_s})"
                  else
                    p "#{comment.user.name} (on #{comment.updated_at.to_s}): #{comment.text}"
                  end
                end
              end
            end
          end
          formtastic_button(form)
        end
      end
    end
  end
end
