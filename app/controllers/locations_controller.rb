class LocationsController < ApplicationController

  resourceful_actions :defaults, :list => :index

  collection_scope :index do |scope|
    scope.active
  end

  display_options :created_at, :name, :active, :venue_link, :assets, :view, :edit,
    :only => [:list, :create, :update]

end
