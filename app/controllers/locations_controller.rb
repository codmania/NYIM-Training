class LocationsController < ApplicationController

  resourceful_actions :defaults, :list => :index

  display_options :created_at, :name, :venue_link, :assets, :view, :edit,
                  :only => [:list, :create, :update]

end
