class CoursesController < ApplicationController

  resourceful_actions :defaults, :select => :show, :list => :index, :promotions => :index

  display_options :name, :course_group, :pos, :hours, :os, :price, :promotion, :assets, :edit, :view, :active,
                  :only => [:list, :create, :update]

  collection_scope :list do |scope|
    scope.order('pos ASC')
  end

  collection_scope :index do |scope|
    scope.active.order('pos ASC')
  end

  collection_scope :promotions do |scope|
    scope.promotions.active.order('pos ASC')
  end

  js :select, :only => true do |page|
    if resource then
      page.replace_html 'signup_scheduled_course_id', view_context.scheduled_courses_dropdown(resource)
    end
  end

end
