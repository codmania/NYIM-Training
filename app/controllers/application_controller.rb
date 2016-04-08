class ApplicationController < ActionController::Base

  protect_from_forgery

  layout 'nyim'

  include Application::ActionAccessor
  include Application::ResourceHandler
  include Application::Paginate
  include Application::Controller
  include Application::ContentFor
  include Application::AccessControl
  include Application::Display

  # this update is needed so that updated site settings take effect in all application instances
  before_filter :update_site

  def update_site
    site_updated_at = session[:site_updated_at]
    Site.clear if site_updated_at && site(:updated_at) < site_updated_at
  end

  # to set default page titles. ajax call sets it via responder to_js
  def resource_title
    if resourceful? && resource
      resource.respond_to?(:name) ? resource.name.humanize : resource.id
    else
      'show'
    end
  end

  document_title :show do
    "#{resource_title} - #{site(:site_name)} - #{site(:seo_tag)}"
  end

  document_title do
    "#{controller_name} > #{action_name} - #{site(:site_name)} - #{site(:seo_tag)}"
  end

  # primary key call used by resource handler
  # chop seo tag from slugd route
  primary_key do
    key = request_options[resource_class.primary_key]
    key.sub(/__.*/, '') unless key.blank?
  end

  # use ssl in production
  before_filter :force_ssl if Rails.env.production?

  # redirect non-ssl requests
  def force_ssl
    if request.ssl? && !use_https? || !request.ssl? && use_https?
      protocol = request.ssl? ? "http" : "https"
      flash.keep
      url = request.url.sub(/http\:\/\/(www\.)?/, 'https://') #use canonical name
      redirect_to url, status: :moved_permanently
    end
  end

  #http://railscasts.com/episodes/357-adding-ssl
  def use_https?
    true # Override in other controllers
  end


  # delegate user role tests to current user and make it available in views
  User::ROLE_TESTS.each do |r|
    define_method(r) do
      current_user.ifnil? { |x| x.send r }
    end
  end
  helper_method User::ROLE_TESTS

  def default_student
    current_student || student? && current_user
  end

  def current_student_id
    @current_student_id ||= session[:student]
    @current_student_id if admin? || user_signed_in? && current_user.child_ids.include?(@current_student)
  end

  def current_student
    @current_student = Student.find_by_id(current_student_id) if current_student_id
  end
  helper_method :current_student, :current_student_id, :default_student

  def current_student=(s)
    @current_student = session[:student] = (s.id if s)
  end


  # generic error for authentication failures
  #include Application::AccessControl::Rescue
  rescue_from CanCan::AccessDenied do |exception|
    action_name       = case exception.action
                          when :new, :create then
                            'create new'
                          when :edit, :update then
                            'modify'
                          else
                            exception.action.to_s.humanize.downcase
                        end
    text              = "You are not authorized to #{action_name}"
    text              += exception.subject.instance_eval do
      case self
        when Class, Symbol, String then
          " #{to_s.humanize.downcase.pluralize}"
        when ActiveRecord::Base then
          " #{self.class.name.humanize.downcase}"
        else
          to_s rescue ''
      end
    end
    current_user_info = current_user ?
        " when logged in as #{current_user.full_name_with_email}" :
        " with missing or wrong credentials"
    text              += current_user_info

    response.headers["ERROR"] = text
    flash[:error]             = 'Unauthorized access'
    respond_to do |format|
      format.html do
        if request.headers['HTTP_ACCEPT_REDIRECT'] == 'false' then
          response.headers["WWW-Authenticate"] = %(Basic realm="Application")
          head :unauthorized
        else
          if defined?(Footnotes) && Rails.env.development? then
            filter = Footnotes::Filter.new(self)
            filter.add_footnotes!
            filter.close!(self)
          end
          render :text => text, :layout => true
        end
      end
      format.js do
        render :update do |page|
          page.replace_html main_container_dom, :text => text
        end
      end
    end
  end

end
