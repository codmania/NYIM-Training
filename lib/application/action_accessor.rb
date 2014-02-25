module Application
  module ActionAccessor
    def self.included(base)

      base.extend ActionAccessorClassMethods
      base.class_eval do

        include ActionAccessorInstanceMethods
      end
    end

    module ActionAccessorInstanceMethods
      def call_component(object, *args)
        case object
          when NilClass
            nil
          when Proc, Method
            object.call self, *(args << true)
          else
            object
        end
      end

      def memoize(name)
        ivar_name = "@_action_accessor_#{name}"
        instance_variable_get(ivar_name) || instance_variable_set(ivar_name, yield)
      end

      def method_name(name, action)
        "_#{name}_for_#{action}"
      end

    end

    module ActionAccessorClassMethods
      def method_name(name, action)
        "_#{name}_for_#{action}"
      end

      def action_accessor(*args)
        args.each do |accessor|
          define_action_accessor_class_set_method(accessor)
          define_action_accessor_instance_get_method(accessor)
        end
      end

      protected

      def define_action_accessor_class_set_method(name, array=nil)
        (
        class << self;
          self;
        end).instance_eval do
          define_method name do |*args, &block|
            values = args.first
            if values.is_a?(Hash)
              values.each do |action, value|
                define_accessor(name, action, value)
              end
            else
              value = Proc.new { |controller, *x| controller.instance_exec(*x, &block) } if block # rescoping the block
              value ||= args.pop
              args = [:default] if args.empty?
              args.each do |action|
                define_accessor(name, action, value)
              end
            end
          end
        end
      end

      def define_accessor(name, action, value)
        method = method_name(name, action)
        define_method method do |*args, &block|
          value
        end
      end

      def define_action_accessor_instance_get_method(name)
        define_method :"#{name}_bang_for" do |action|
          memoize :"#{name}_bang_#{action}" do
            method = method_name(name, action)
            method = method_name(name, action_type(action)) unless respond_to? method
            method = method_name(name, :default) unless respond_to? method
            send(method) if respond_to? method
          end
        end

        define_method :"#{name}_for" do |action, *args, &block|
          call_component(send(:"#{name}_bang_for", action), *args, &block)
        end

        define_method :"#{name}!" do
          memoize :"#{name}_bang" do
            send(:"#{name}_bang_for", action_name)
          end
        end

        define_method name do |*args, &block|
          call_component(send(:"#{name}_bang_for", action_name), *args, &block)
        end
      end


    end

  end
end
