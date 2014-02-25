class TestimonialsController < ApplicationController

  resourceful_actions :defaults, :list => :index, :manage => :index, :manage_update => :update

  collection_scope :index do |scope|
    scope.testimonials
  end

  collection_scope :list do |scope|
    scope
  end

  collection_scope :manage, :manage_update do |scope|
    scope.where(:course_id.eq => nil)
  end

  per_page :manage => 1, :manage_update => 1

  fallback_action :manage_update => [nil, :manage]

  action_component :manage_update do
    save_resource
    self.resource = paginate(init_collection) unless resource.new_record?
  end

  display_options :created_at, :read, :display, :featured, :student_info, :class_info, :text, :teacher, :course, :edit,
                  :only => [:list, :create, :update]

end
