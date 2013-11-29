require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :application, "vouchers.domain4now.com"
set :repository,  "git@github.com:divyatalwar/rails-project.git"
set :scm, :git
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :server, :passenger
set :use_sudo, false
set :user, :deploy
set :stages, %w(production)
set :keep_releases, 5

default_run_options[:pty] = true

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"
namespace :deploy do
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
 
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
   
  before "deploy:assets:precompile" do
    run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    # run "ln -s #{shared_path}/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end
    
  desc "Deploy with migrations"
  task :long do
    transaction do
      update_code
      web.disable
      symlink
      migrate
    end
    restart
    web.enable
    cleanup
  end

  desc "Run cleanup after long_deploy"
  task :after_deploy do
    cleanup
  end

  
end

desc "Display log tail -f"
task :tail_log, roles: :app do 
  run "tail -f #{shared_path}/log/#{rails_env}.log"
end

require './config/boot'