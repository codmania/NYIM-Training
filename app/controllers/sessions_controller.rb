class SessionsController < Devise::SessionsController

  # ajaxified along these lines
  # https://groups.google.com/forum/?hl=en#!searchin/plataformatec-devise/viktor/plataformatec-devise/2NX-DwrIoN4/dQBC69PZVvMJ

  # this is to allow relogin (as diff user)
  skip_before_filter :require_no_authentication

  layout 'login'

  main_container_dom :new, :loginbox
  main_container_dom :create do
    success ? :content : :loginbox
  end

  resource_to_authorize :session

  resourceful_actions :new, :create, :destroy

  def refresh_header_and_sidebar(page)
    page.replace 'header', render_to_string(:widget => Views::Site::NyimHeader)
    page.replace 'sidebar', render_to_string(:widget => Views::Site::UserPanel)
    if current_user.is_a?(Teacher)
      page.replace_html main_container_dom, render_to_string(:widget => Views::Teachers::Show.new(:resource => current_user))
    end
  end

  js :new do |page|
    page.show 'loginbox'
    page.show 'dimmer'
  end

  js :create, :only => true do |page|
    if success
      page.hide 'loginbox'
      page.hide 'dimmer'
      refresh_header_and_sidebar(page)
    end
  end

  js :destroy, :only => true do |page|
    refresh_header_and_sidebar(page)
    page.replace_html main_container_dom, render_to_string(:widget => Views::Assets::Asset.new(:resource => 'main'))
  end

  action_component :new do
    #resource = build_resource
    #clean_up_passwords(resource)
    #respond_with_navigational(resource, stub_options(resource)){ render_with_scope :new }
    clean_up_passwords build_resource
  end

  def devise_sign_out
    if Devise.sign_out_all_scopes
      sign_out
    else
      sign_out(resource_name)
    end
  end

  action_component :destroy do
    devise_sign_out
    self.redirect = true
  end

  # POST /resource/sign_in
  action_component :create do
    #resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    devise_sign_out
    @show = user = warden.authenticate(:scope => resource_name)
    if self.success = !!user
      sign_in(resource_name, user)
      @current_user = user
    else
      clean_up_passwords build_resource
    end
    self.redirect = true
    #respond_with resource, :location => redirect_location(resource_name, resource)
  end

end
