set :branch, "master"
set :rails_env, 'production'
set :deploy_to, "/var/www/#{application}"
set :ssh_options, { :forward_agent => true }
role :web, "176.58.108.178"
role :app, "176.58.108.178"
role :db,  "176.58.108.178", :primary => true