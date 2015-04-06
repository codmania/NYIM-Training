module ControllerSpecHelper
  def login(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = user.is_a?(User) ? user : Factory.create(user)
    sign_in @current_user
  end

  def check_success(template = nil)
    response.should be_success
    response.should render_template template if template
  end

  def check_redirect(template = nil)
    response.should be_redirect
    response.should render_template template if template
  end
end
