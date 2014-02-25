class SitesController < ApplicationController

  before_filter :set_site, :only => [:edit, :index, :update, :reset]

  resourceful_actions :edit, :index, :update, :clear => :update, :reset => :destroy, :manage_emails => :index

  show = Views::Site::Show
  action_widget :index => Views::Site::Show, :manage_emails => Views::Site::ManageEmails

  fallback_action :reset => [show, show], :clear => [show, show], :update => [show, show]

  action_component :update do
    save_resource
    session[:site_updated_at] = resource.updated_at unless resource.respond_to?(:errors) && !resource.errors.empty?
    set_site
  end

  action_component :reset do
    destroy_resource
    flash[:notice] = 'site settings reset to defaults'
    set_site
  end

  action_component :clear do
    Site.clear
    flash[:notice] = 'site settings reread'
    set_site
  end

  protected
  def set_site
    self.resource = Site.get_or_set
  end


end