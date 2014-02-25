class Views::Signups::Certificate < Application::Widget
  def widget_content
    signup = resource
    case 
      when signup.completed? || signup.awarded?
        h1 'Certificate'
        text 'Your certificate is ready. '
        link_to 'View it here.', disclose_certificate_signup_path(signup), 
        :remote => false,
        #:popup => ['Certificate', 'scrollbars=no,resizable=no,height=600,width=800'],#, :target => "_blank" 
        :onclick => "window.open(this.href,'Certificate','scrollbars=no,resizable=no,height=600,width=800');return false;"   
      when signup.upcoming?
        text 'certificate only available once you complete the class and leave feedback'
      when signup.can_have_feedback?
        widget Views::Signups::Feedback
      else
        text 'Certificate not available'
    end
  end
end
