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
# ssh_options[:forward_agent] = true

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

