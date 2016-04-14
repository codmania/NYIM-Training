class CourseGroupsController < ApplicationController

  resourceful_actions :defaults, :list => :index

  collection_scope :list do |scope|
    scope.order('pos ASC', 'name ASC')
  end

  collection_scope :index do |scope|
    scope.active.order('pos ASC', 'name ASC')
  end

  js :update, :create, :destroy do |page|
    course_menu = render_to_string :widget => Views::Site::CourseMenu
    page.replace :course_menu, :text => course_menu
  end

  display_options :name, :pos, :assets, :edit, :view, :active, :only => [:list, :create, :update]


end
