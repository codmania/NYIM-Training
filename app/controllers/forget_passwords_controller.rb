class ForgetPasswordsController < Devise::PasswordsController

  resourceful_actions :new, :edit, :create, :update
  resource_to_authorize :forget_passwords

  action_component :new, :edit do
    self.resource = User.new
    resource.reset_password_token = params[:reset_password_token] if params[:reset_password_token]
  end

  action_component :create do
    self.resource = User.send_reset_password_instructions(params[resource_name])
    self.success = successfully_sent?(resource)
  end
  
  action_component :update do
    self.resource = User.reset_password_by_token(params[resource_name])
    self.success = resource.errors.empty?
    sign_in(resource_name, resource) if success
  end
  
  js :new do |page,controller|
    page.hide 'loginbox'
    page.hide 'dimmer'
  end

end