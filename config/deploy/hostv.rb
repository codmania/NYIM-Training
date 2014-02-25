server '207.210.201.229', :web, :app, :db, :primary => true
set :branch, "master"
set :deploy_to, "/home/training/nyim"
set :user, "training"

set :use_sudo, false

set(:service_root) { "#{shared_path}/service" }
