class ScheduledSessionsController < ApplicationController
  
  resourceful_actions :index
  
  def index_to_json(items)
    items.map(&:to_calendar)
  end
    
  collection_scope do |scope|
    scope.order('starts_at ASC')
  end

end
