class FeedbacksController < ApplicationController

  resourceful_actions :defaults, :check => :index, :list => :index, :check_update => :update

  collection_scope :check, :check_update do |scope|
    scope.where(:read.not_eq => true)
  end

  per_page :check => 1, :check_update => 1

  fallback_action :check_update => [:check, :check]

  action_component :check_update do
    save_resource
    self.resource = paginate(init_collection) unless resource.new_record?
  end

  display_options :created_at, :teacher, :course, :student, :text, :comment, :view, :read, :display,
                  :only => [:list, :create, :update]

  display_options :created_at, :teacher, :course, :student, :only => [:show ]
end
