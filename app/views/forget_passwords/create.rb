class Views::ForgetPasswords::Create < Application::Widget
  def widget_content
    h1 'Forgot your password'
    if controller.success
      text 'reset password instructions have been sent'
    else
      text 'email not found, reset password instructions have NOT been sent'
      widget Views::ForgetPasswords::New
    end
  end
end