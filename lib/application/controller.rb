module Application
  module Controller

    DEFAULT_ACTIONS      = [:new, :create, :destroy, :show, :index, :update, :edit]
    DEFAULT_ACTION_TYPES = { }
    DEFAULT_ACTIONS.each { |a| DEFAULT_ACTION_TYPES[a] = nil }

    def self.included(base)

      base.extend ControllerClassMethods
      base.class_eval do

        action_accessor :action_component
        action_component :create! do
          save_resource
        end
        action_component :update! do
          save_resource
        end
        action_component :destroy! do
          destroy_resource
        end

        action_accessor :fallback_action
        fallback_action :create! => [:new, nil],
                        :update! => [:edit, nil]

        action_accessor :js_block
        action_accessor :js_only

        action_accessor :action_widget
        action_widget :create!  => 'show',
                      :update!  => 'show',
                      :destroy! => 'show'

        action_widget do
          action_type.to_s.chop
        end

        action_accessor :cache_expiry

        attr_accessor :success, :redirect

        respond_to :html, :js, :json, :xml

        include ControllerInstanceMethods
        include Application::ContentFor

        helper_method :render_to_string, :js, :js_only, :document_title, :main_container_dom,
                      :action_widget, :widget_class, :success
      end
    end

    module ControllerClassMethods

      def resourceful_actions(*args)
        options = args.extract_options!
        actions = DEFAULT_ACTION_TYPES
        actions = actions.slice(*args) unless args.include?(:defaults)
        actions.merge!(options) if options

        actions.each do |action, type|
          method = "_type_for_#{action}"
          class_attribute method, :instance_reader => false, :instance_writer => false unless respond_to? method
          send(:"#{method}=", :"#{type||action}!")
          define_method action do
            action_component
            respond
          end
        end

      end

      def js(*args, &block)
        options = args.extract_options!
        js_only(*(args.dup.push(true))) if options[:only]
        js_block(*args, &block)
      end

    end

    module ControllerInstanceMethods

      def action_type(action=action_name)
        memoize "action_type_#{action}" do
          type = begin
            self.class.send(:"_type_for_#{action}")
          rescue NoMethodError
          end
          type || :"#{action}!"
        end
      end

      def widget_action(action)
        action || action_widget #|| action_type.to_s.chop
      end

      def widget_class(action = nil)
        return @widget_class if @widget_class
        widget = action.is_a?(Class) ? action : widget_action(action)
        unless widget.is_a?(Class)
          widget = "#{widget_base_class}::#{widget.to_s.classify}"
          begin
            widget = widget.constantize
          rescue
            raise(ArgumentError, "widget '#{widget}' does not exist")
          end
        end
        @widget_class = widget
      end

      def action_new?
        action_type == :new!
      end

      def responder
        Application::Responder
      end

      def respond
        logger.info "cache_expired?: #{cache_expired?}"
        respond_with resource, :responder => responder if cache_expired?
      end

      def cache_expired?
        !cache_expiry || stale?(cache_expiry)
      end

      def save_resource
        resource.save
      end

      def destroy_resource
        resource.destroy
      end

      def widget_base_class
        "Application::Widgets"
      end

    end
  end
end
