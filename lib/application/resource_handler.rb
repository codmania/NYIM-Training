module Application::ResourceHandler

  def self.included(base)
    base.class_eval do

      action_accessor :member_scope, :primary_key
      action_accessor :collection_scope
      action_accessor :request_options
      action_accessor :resource_class, :resource_name, :resource_default, :resource_param

      resource_name do
        self.class.name.underscore.sub(/_controller/, '').singularize
        #model_name
      end

      resource_class do
        (resource_params.is_a?(Hash) && resource_params[:type] || resource_name.classify).constantize
      end

      primary_key do
        request_options[resource_class.primary_key]
      end

      member_scope do
        # if a primary key is given, resource with that key is retrieved
        r = !primary_key.blank? && resource_class.find(primary_key)
      end

      resource_param do
        request_options[:resource_param] || resource_name
      end

      request_options do
        params
      end

      include ResourceHandlerInstanceMethods

      helper_method :resource, :resource_class, :resourceful?
    end
  end

  module ResourceHandlerInstanceMethods

    def base_scope
      resource_class.unscoped
    end

    def resourceful?
      resource_class && resource_class.respond_to?(:primary_key) rescue nil
    end

    def resource(batch=false, &block)
      return nil unless resourceful?
      apply(@resource ||= init_resource, batch, &block)
    end

    def resource=(arg)
      @resource = arg
    end

    def resource_params
      request_options[resource_param] || { }
    end

    def init_collection
      base  = base_scope
      scope = collection_scope(base) || base
      scope = accessible_scope(scope) if respond_to? :accessible_scope
      if resource_class.respond_to?(:search)
        if request_options[:search].blank?
          @search_options = base_scope.search
          scope
        else
          @search_options = scope.search(request_options[:search])
        end
      else
        scope
      end
    end

    protected

    def new_resource
      init = resource_default! && proc { |r| resource_default!.call(self, r) }
      resource_class.new(resource_params, &init)
    end

    def init_resource
      r = member_scope
      if action_new? || request.post?
        r ||= new_resource
      else
        # otherwise retrieve search both for get and bulk update
        collection = !r
        r          ||= init_collection
        # if put request and attributes modified then update_attributes
        apply r do |x|
          x.update_attributes(resource_params) if resource_params
          resource_default(x)
        end if r && request.put?
        r = paginate(r) if collection && respond_to?(:paginate)
      end
      r
    end

    def apply(object, batch=false, &block)
      if block
        if object.respond_to?(:each)
          if batch
            steps = object.count/batch
            (0..steps).each do |step|
              object.limit(batch).offset(step*batch).each &block
            end
          end
          object.each &block
        else
          if block.arity == 0
          then
            object.instance_eval &block
          else
            yield object
          end
        end
      end
      object
    end

  end
end
