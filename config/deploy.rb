require "rvm/capistrano"

set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment

before 'deploy:setup', 'rvm:install_rvm'  # install RVM
before 'deploy:setup', 'rvm:install_ruby' # install Ruby and create gemset, OR:
set :rvm_install_type, :stable

require './config/boot'
require 'airbrake/capistrano'

# bundler bootstrap
#http://github.com/carlhuda/bundler/blob/master/lib/bundler/capistrano.rb
require 'bundler/capistrano'

#https://github.com/capistrano/capistrano/wiki/2.x-Multistage-Extension
set :stages, %w(linode hostv oldhostv)
set :default_stage, "hostv"
require 'capistrano/ext/multistage'

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# main details
set :application, "nyim"

# repo details
set :deploy_via, :remote_cache
set :scm, :git
set :repository, "git@github.com:3rdI/nyim.git"

#https://github.com/capistrano/capistrano/issues/79
set :normalize_asset_timestamps, false

# tasks
set(:system_files_path) { "#{release_path}/config/deploy/#{stage}" }
set(:delayed_job_service) { "#{system_files_path}/delayed_job_service" }
set(:delayed_job_path) { "#{service_root}/#{application}_#{rails_env}_delayed_job" }
set(:crontab_path) { "#{system_files_path}/crontab" }

# shared tasks
namespace :crontab do
  desc "install crontab"
  task :install do
    sudo "crontab -u #{user} #{crontab_path}"
  end
end

after "deploy:start", "crontab:install"
after "deploy:restart", "crontab:install"

namespace :shared do
  desc "link to legacy assets"
  task :legacy do
    run "ln -sf #{shared_path}/legacy #{current_path}/public/legacy"
  end
end

after "deploy:start", "shared:legacy"
after "deploy:restart", "shared:legacy"

namespace :delayed_job do
  desc "Shut off supervise"
  task :off, :roles => :app do
    delayed_job.stop
    sudo "killgrep 'svscan #{service_root}'"
    sudo "killgrep supervise"
    sudo "killgrep script/delayed_job"
  end
  desc "Switch on supervise"
  task :on, :roles => :app do
    sudo "ps aux|grep -v grep|grep -q 'svscan #{service_root}'|| (svscan #{service_root}&) && sleep 5"
  end
  desc "Start delayed job"
  task :start, :roles => :app do
    delayed_job.stop
    sudo "ln -sf #{delayed_job_service} #{delayed_job_path}"
    #sudo "svc -u #{delayed_job_path}"
  end
  desc "Stop delayed job"
  task :stop, :roles => :app do
    #http://cr.yp.to/daemontools/faq/create.html#remove
    run "cd -L #{delayed_job_path}/ && sudo rm -rf #{delayed_job_path} && sudo svc -dx . log || echo 'already off'"
  end
  task :relaunch, :roles => :app do
    delayed_job.stop
    run "sudo mkdir -p #{service_root}"
    run "mkdir -p #{shared_path}/log/delayed_job_service"
    run "ln -sf #{shared_path}/log/delayed_job_service #{delayed_job_service}/log/main"
    run "ln -sf delayed_job_service/current #{shared_path}/log/delayed_job_service.log"
    run "chmod +x #{delayed_job_service}/run"
    run "chmod +x #{delayed_job_service}/log/run"
    delayed_job.start
  end
end

after "deploy:start", "delayed_job:relaunch"
after "deploy:stop", "delayed_job:stop"
after "deploy:restart", "delayed_job:relaunch"
