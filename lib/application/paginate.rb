module Application::Paginate

  def self.included(base)

    base.class_eval do

      # to override in controllers
      # I do not support model-specified pagination setting, it is a view/UI thing
      # not inherent in business logic

      action_accessor :per_page, :paginate

      paginate do |scope|
        scope.paginate(:page => request_options[:page], :per_page => per_page || request_options[:per_page])
      end

    end

  end
end

