module Application::AccessControl

  def self.included(base)

    User.class_eval do
      include UserAccessControlInstanceMethods
    end
    base.extend(AccessControlClassMethods)
    base.class_eval do
      include AccessControlInstanceMethods

      User::ROLE_TESTS.each do |r|
        define_method(r) do
          current_user.is_a?(User) && current_user.role == r
        end
      end
      helper_method User::ROLE_TESTS
      before_filter :authorize

      action_accessor :resource_to_authorize
      resource_to_authorize do
        case resource
        when Array, NilClass, FalseClass, ActiveRecord::Relation then
          resource_class rescue resource_name.underscore.to_sym
        else
          resource
        end
      end

    end


  end
end

module AccessControlClassMethods

end

module UserAccessControlInstanceMethods


  def ability
    @ability ||= Ability.new(self)
  end

  delegate :can?, :cannot?, :to => :ability

end

module AccessControlInstanceMethods

  def accessible_scope(scope)
    scope.accessible_by(current_ability)
  end

  def current_ability
    # request.remote_ip
    @current_ability ||= Ability.new(current_user, request.local? || request.remote_ip == '207.210.201.229')
  end

  def authorize
    logger.debug ['Access control:', current_user && current_user.email, authorize_action, authorize_subject].inspect
    authorize! authorize_action, resource_to_authorize
  end

  def authorize_action
    action_name.to_sym
  end

  def authorize_subject
    resource_to_authorize.is_a?(ActiveRecord::Base) ?
      [resource_to_authorize.class.name, resource_to_authorize.id] :
      resource_to_authorize.to_s
  end
end
