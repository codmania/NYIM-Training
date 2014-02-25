module Application
  module ActionAccessors
    def self.included(base)

      base.extend ActionAccessorsClassMethods
      base.class_eval do

        include ActionAccessorsInstanceMethods
      end
    end

    module ActionAccessorsInstanceMethods
      def call_component(object, *args)
        case object
          when NilClass
            nil
          when Symbol
            send object, *args
          when Proc, Method
            object.call self, *(args << true)
          else
            object
        end
      end

      def fallback_cascade
        @fallback_cascade ||= [action_name.to_sym, action_type || :_dummy, request.request_method_symbol, :all]
      end

      # should be an object method
      def memoize(name)
        ivar_name = "@_action_accessor_#{name}"
        instance_variable_get(ivar_name) || instance_variable_set(ivar_name, yield)
      end

    end

    module ActionAccessorsClassMethods
      def action_accessor(*args)
        options = args.extract_options!
        array   = options[:array]
        args.each do |accessor|
          define_action_accessor_store(accessor)
          define_action_accessor_store("default_#{accessor}", true)
          define_action_accessor_class_set_method("default_#{accessor}", array)
          define_action_accessor_class_method(accessor)
          define_action_accessor_instance_method(accessor, array)
          define_action_accessor_class_set_method(accessor, array)
        end
      end

      def define_action_accessor_instance_method(name, array=nil)
        method  = array ? name.to_s.pluralize : name
        default = array && []
        define_method "#{method}!" do
          memoize method do
            self.class.send(name.to_s.pluralize, *fallback_cascade) || default
          end
        end
        if array
          define_method method do |*args|
            send("#{method}!").each { |c| call_component(c, *args) }
          end
        else
          define_method method do |*args|
            call_component(send("#{method}!"), *args)
          end
        end
      end

      def retrieve(store, *fallback_cascade)
        key, *acc = fallback_cascade
        if key
          send(store)[key] || retrieve(store, *acc)
        end
      end

      def define_action_accessor_class_method(name)
        (
        class << self;
          self;
        end).instance_eval do
          define_method name.to_s.pluralize do |*fallback_cascade|
            retrieve("_#{name}_store", *fallback_cascade) ||
                retrieve("_default_#{name}_store", *fallback_cascade)
          end
        end
      end

      def define_action_accessor_store(name, setter=nil)
        store        = "_#{name}_store"
        store_setter = "#{store}="
        #class_inheritable_accessor store.to_sym
        #http://apidock.com/rails/Class/class_attribute
        class_attribute store.to_sym, :instance_reader => false, :instance_writer => false
        send store_setter, { }
        if setter
          (
          class << self;
            self;
          end).instance_eval do
            define_method name.to_s.pluralize do |*args|
              send(args.empty? ? store : store_setter, *args)
            end
          end
        end
      end

      def define_action_accessor_class_set_method(name, array=nil)
        (
        class << self;
          self;
        end).instance_eval do
          define_method name do |*args, &block|
            store = send("_#{name}_store")
            if args.first.is_a?(Hash)
              args.first.each do |action, value|
                array ?
                    (store[action] ||= []) << value :
                    store[action] = value
              end
            else
              value = if block # rescoping the block
                        Proc.new { |controller, *x| controller.instance_exec(*x,&block) }
                      else
                        args.pop
                      end
              args = [:all] if args.empty?
              args.each do |action|
                array ?
                    (store[action] ||= []) << value :
                    store[action] = value
              end
            end
            store
          end
        end
      end

    end
  end
end
