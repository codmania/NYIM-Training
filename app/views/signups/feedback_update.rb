class Views::Signups::FeedbackUpdate < Views::Signups::Feedback
  def widget_content
    if controller.success
      signup = resource
      div :id => 'success', :class => 'box_striped' do
        p do
          text "Thank you very much for your feedback. We have sent you your certificate to #{signup.student.email}. You can also "
          link_to "view your certificate", certificate_signup_path(signup)
          text ", or " 
          link_to "check out the course materials on our resources page.", display_asset_path(signup.course.resources_asset_name) 
        end
      end
    else
    super
    end
  end

end
