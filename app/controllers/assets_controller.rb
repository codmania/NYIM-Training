class AssetsController < ApplicationController

  resourceful_actions :defaults, :asset => :show, :manage => :index, :list => :index, :select => :index

  resource_default do |r|
    r.content = nil unless resource_params && resource_params[:asset].blank?
  end

  #cache_expiry do
  #  expires_in 1.minutes
  #  { :etag => '0'}
  #end

  action_component :asset do
    self.resource = ProxyString.new(params[:asset])
  end

  display_options :name, :format, :updated_at, :asset_file_size, :assets, :edit, :content, :download, :delete,
    :only => [:menu_items, :list, :create, :update, :select]
  display_options :name, :format, :updated_at, :asset_file_size, :edit, :content, :download, :delete,
    :only => [:manage]

  collection_scope :select do |scope|
    type = params[:type]
    if !type.blank?
      scope_method = "#{type}_scope"
      if scope.respond_to?(scope_method)
        scope.send(scope_method)
      end
    end
  end

  collection_scope do |scope|
    scope.order('created_at DESC')
  end

  js :destroy, :only => true do |page|
    page.hide(dom_id(resource))
  end

  def content
    # this is silly for img/binary assets
    send_data resource.read,
      :disposition => 'inline',
      # we enforce utf-8
      :encoding    => 'utf8',
      # type could be read from the file content type
      # but we want to enforce text display for xml files as well
      # we enforce utf-8 charset
      :type        => "text/plain; charset=utf-8"
  end

  def download
    send_data resource.read,
      :disposition => 'attachment',
      # we enforce utf-8 charset
      :encoding    => 'utf8',
      # :FIXME: rails 3.2 send_file now guesses the MIME type from the file extension if :type is not provided.
      :type        => resource.asset_content_type,
      :filename    => URI.encode(resource.asset_file_name)
  end

  document_title :asset do
    if resource == 'main'
      "#{site(:site_name)} - #{site(:seo_tag)}"
    else
      "#{resource} - #{site(:site_name)} - #{site(:seo_tag)}"
    end
  end

end
