class UsersController < ApplicationController

  resource_default do |r|
    r.created_by = current_user
  end

  resourceful_actions :defaults, :autocomplete => :index

  collection_scope :autocomplete do |scope|
    scope = scope.name_like(request_options[:term])
    scope = scope.where(:created_by_id.eq => current_user.id) if student?
    scope
  end

  def autocomplete_to_json(items)
    items = items.map do |item|
      s = item.full_name_with_email
      {"id" => item.id, "label" => s, "value" => s }
    end
    items.unshift({ "id" => 0, "label" => 'New Student', "value" => 'New Student' })
  end

end
