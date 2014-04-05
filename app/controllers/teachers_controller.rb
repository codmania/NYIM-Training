class TeachersController < UsersController

  resourceful_actions :defaults, :list => :index

  collection_scope :index do |scope|
    scope.active.order(:position)
  end

  collection_scope :list do |scope|
    scope.order(:position)
  end

  display_options :user_name, :created_at, :active, :position, :photo, :assets, :edit,
    :only => [:list, :show, :create, :update]

end
