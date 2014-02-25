class JobsController < ApplicationController

  resourceful_actions :index, :show, :destroy,
                      :restart => :update, :fail => :update, :clear => :index,
                      :launch  => :create, :tasks => :index, :list => :index

  display_options :tag, :description, :job_status, :attempts, :manage_job,
                  :only => [:list]

  collection_scope :list do |scope|
    scope.order('created_at DESC')
  end

  js :restart, :fail, :only => true do |page|
    page.replace_html dom_id(resource, :status), :text => resource.status if success
  end

  action_component :restart do
    dt           = params[:job] && params[:job][:run_at] || Time.now
    self.success = resource.update_attribute(:run_at, dt)
  end

  action_component :fail do
    self.success = resource.update_attribute(:fatal, true)
  end

  action_component :clear do
    resource_class.delete_all
    self.resource = paginate(init_collection)
  end

  # launch action is entry point for cron jobs
  respond_to :text, :only => :launch

  layout :set_layout

  def set_layout
    if action_name == 'launch' &&
        request.format == 'text'
      false
    else
      'nyim'
    end
  end

  action_component :launch do
    task    = params[:task]
    force   = params[:force] == '1'
    msg     = "[JOBS][CONTROLLER][#{Time.now}] '#{task}' "
    success = NyimJobs::Base.launch(task, force, :user => current_user)
    msg << (success ? "scheduled" : "unknown")
    @result = msg
    logger.info msg
  end

end
