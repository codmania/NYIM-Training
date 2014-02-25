class CompaniesController < ApplicationController

  resourceful_actions :defaults, :autocomplete => :index, :list => :index

  collection_scope :autocomplete do |scope|
    scope.where(:name.matches => "#{request_options[:term]}%").order_clients
  end

  collection_scope :index do |scope|
    scope.clients
  end

  collection_scope :list do |scope|
    scope
  end

  def autocomplete_to_json(items)
    items.map { |item| {"id" => item.id, "label" => "#{item.name}", "value" => item.name }}
  end

  display_options :created_at, :name, :url, :display_with_url, :display_as_client, :featured, :edit,
                  :only => [:list ,:show, :create,:update]

  per_page :index => 100, :list => 30

end
