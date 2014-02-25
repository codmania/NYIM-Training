#require 'devise/password_controller'

class Devise::PasswordController
  
  def resource_to_authorize
    :devise_password_reset
  end

end