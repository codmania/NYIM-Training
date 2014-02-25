class Views::ForgetPasswords::Update < Application::Widget
  def widget_content
    h1 'Change your password'
    if controller.success
      text 'Your password has been successfully reset'
    else
      text resource.errors.inspect
      unless resource.errors[:reset_password_token].blank?
        text 'Invalid token: password cannot be reset'
      else
        widget Views::ForgetPasswords::Edit
      end
    end
  end
end
