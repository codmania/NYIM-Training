class Views::Signups::RescheduleUpdate < Views::Signups::Reschedule
  def widget_content
    if controller.success
      signup = resource.retake
      other_student = current_user == resource.student ? '' : " (for #{resource.student.full_name_with_email})"
      course        = resource.name
      if signup
        div :id => 'success', :class => 'box_striped' do

          date = signup.starts_at.to_s(:short)
          p do
            if signup.confirmed?
              text "You have rescheduled your #{course} course#{other_student}: new starting date is #{date}"
              self.resource = signup
            else
              text "To complete rescheduling, proceed to checkout by clicking on your cart in the sidebar or choose another date"
            end
          end
        end
        super
      else
        div :id => 'success', :class => 'box_striped' do
          p do
            if resource.released?
              text "You have canceled your #{course} course#{other_student}"

            else
              text "To complete your cancelation, proceed to checkout by clicking on your cart in the sidebar or choose another date"
            end
          end
        end
        super unless resource.released?
      end

    else
      super
    end
  end

end
