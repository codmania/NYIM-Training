class AdminsController < ApplicationController

  resourceful_actions :defaults, :list => :index

  display_options :user_name, :created_at, :created_by, :edit, :only => [:list ,:show, :create,:update]

end
