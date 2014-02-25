class Application::Responder < ActionController::Responder

  delegate :main_container_dom, :render_to_string, :js_blocks, :js_only, :widget_class, :widget_action,
  :action_name, :success, :fallback_action, :document_title, :logger, :current_user, :redirect, :content_for,
  :to => :controller
  #https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/responder.rb
  def default_action
    fallback_action && fallback_action[has_errors? ? 0 : 1] || has_errors? && super
  end

  def has_errors?
    #resource.respond_to?(:errors) && !resource.errors.empty?
    #this is to bypass non-standard resources (bulk create? etc)
    success.nil? ? super : !success
  end

  def to_json
    json_helper = "#{controller.action_name}_to_json"
    json = controller.respond_to?(json_helper) ? controller.send(json_helper,resource) : resource.map(&:to_json)
    render :json => json
  end

  #  def to_html
  #    default_render
  #  rescue ActionView::MissingTemplate => e
  #    navigation_behavior(e)
  #  end
  #  def navigation_behavior(error)
  #    if get?
  #      raise error
  #    elsif has_errors? && default_action
  #      render :action => default_action
  #    else
  #      redirect_to navigation_location
  #    end
  #  end

  def redirect_to(*options)
    target = fallback_action[2]
    if target
      target = controller.instance_exec(*options,&target)
      logger.debug "redirection path: #{target}" unless target.blank?
    super(target)
    else
    options.empty? ? super(current_user) : super(*options)
    end
  end

  def redirect?
    redirect.nil? ? !get? && !has_errors? : redirect
  end

  # this takes care that view templates for create/update actions will only be displayed
  # if no errors
  # the default rails 3 responder behaviour is to render named template and only if
  # it does not exist fall back to navigation behaviour
  # UPDATE this is the correct behaviour
  # however this is not really resourceful behaviour
  # custom renders for success and failure can be given, which provide an easy way to define
  # alternative template name for actions
  # if no custom template specified we fall back to default then fallback to navigation behaviour
  # (which e.g. redirects to show on update success)
  # if no custom method given, but a non-get action exists as a template it will be rendered
  # not redirected on success
  def to_html

    render_method = redirect? ? :redirect_to : :render
    begin
      render
    rescue ActionView::MissingTemplate
      begin
        if default_action
          #now this is sensitive to success state
          logger.debug "responder rendering: \ntrying #{render_method} #{default_action}"
          send render_method, :action => default_action
        else
          logger.debug "trying default"
          default_render
        end
      rescue ActionView::MissingTemplate
        if render_method == :redirect_to
          logger.debug "falling back to redirect resource to #{widget_action(default_action)}"
          send render_method, resource || current_user, :action => widget_action(default_action)
        else
          logger.debug "falling back to generic scaffold for #{widget_action(default_action)}"
          w = widget_class(default_action)
          logger.warn "render erector widget #{w}"
          send render_method, navigation_location
        end
      end
    end
  end

  def to_js
    # similar to html request behaviour
    # set fallback template or fall back to action name
    begin # try js.erb etc templates before
      logger.debug "responder rendering: \ntrying js templates for #{action_name}"
      render :action => action_name, :layout => false, :extensions => ['js.erb','rjs','js']
    rescue ActionView::MissingTemplate
      action = default_action
      render :update do |page|
        unless js_only || !controller.params[:no_render].blank?
          # render the html template into a string with controller scope
          logger.debug "falling back to content update with html template"
          main = begin
            logger.debug "trying with custom view for #{action_name}"
            controller.render_to_string :action => action_name, :layout => false
          rescue ActionView::MissingTemplate => e
            begin
              if action && !action.is_a?(Class) && action.to_s != action_name
                logger.debug "trying with custom view for #{action}"
                controller.render_to_string :action => action, :layout => false
              else
                raise e
              end
            rescue ActionView::MissingTemplate
              logger.debug "falling back to generic scaffold for #{controller.widget_action(action)}"
              widget_class = controller.widget_class(action)
              logger.debug "render erector widget #{controller.widget_class}"
              controller.render_to_string :widget => controller.widget_class
            end
          end

          # render the html template by replacing inner html of main container
          page.replace_html controller.main_container_dom, :text => main
          controller.set_document_title(page)
          controller.scrolltop(page)
        end
        controller.js_block(page) if controller.params[:no_render].blank?

      end #update
    end
  end

  def navigation_location
    # this should work but buggy see
    # https://groups.google.com/forum/?fromgroups#!topic/erector/jI9EDj29Qk4
    #{ :file => "#{Rails.root}/lib/application/widgets/#{controller.action_type}" }
    { :template => "site/widget" }
  end

  #rails 3.2 :FIXME:
  #Passing formats or handlers to render :template and friends like render :template => “foo.html.erb” is deprecated. Instead, you can provide :handlers and :formats directly as an options:  render :template => “foo”, :formats => [:html, :js], :handlers => :erb.
  #
  def render(options={},*args)
    return super unless options.is_a? Hash
    extentions = options.delete(:extensions)
    if extentions
      action = options.delete(:action) or raise(ArgumentError,"action has to be given to try extensions")
      exception = nil
      extentions.any? do |ext|
        options[:action] = "#{action}.#{ext}"
        begin
          super(options,*args) && true
        rescue ActionView::MissingTemplate => e
        exception = e
        false
        end
      end or raise exception
    else
    super(options,*args)
    end
  end

end