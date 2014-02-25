class ScheduledCoursesController < ApplicationController

  resourceful_actions :defaults,
                      :add_seats => :update, :remove_seats => :update, :close => :update,
                      :select    => :show, :list => :index

  collection_scope :list do |scope|
    scope.order('starts_at ASC')
  end

  collection_scope :index do |scope|
    scope.active.order('starts_at DESC')
  end

  display_options :name, :course, :starts_at, :price, :promotion, :seats_available, :edit, :manage_seats, :view, :active,
                  :only => [:list, :create, :update]

  action_component :add_seats, :remove_seats, :close do
    verified_request?
    self.success = resource.send(action_name) && resource.save
  end

  js :add_seats, :remove_seats, :close, :only => true do |page|
    page.replace_html dom_id(resource, :seats), :text => resource.show_seats_available if success
  end

  def index_to_json(items)
    items.map(&:to_calendar)
  end

  js :select, :only => true do |page|
    if resource then
      page.replace_html 'signup_os', view_context.os_dropdown(resource)
      page.replace_html 'selected_class',
                        render_to_string(:widget => Views::ScheduledCourses::Select.new(:course => resource))
    end
  end
end
