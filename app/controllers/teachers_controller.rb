class TeachersController < UsersController

  resourceful_actions :defaults, :list => :index

  collection_scope :index do |scope|
    scope.active
  end

  collection_scope :list do |scope|
    scope
  end

  display_options :user_name, :created_at, :active, :photo, :assets, :edit,
                  :only => [:list, :show, :create, :update]

end
