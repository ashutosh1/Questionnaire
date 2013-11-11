require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :application, "questionnaire"
set :repository,  "git@github.com:ashutosh1/Questionnaire.git"
set :scm, :git
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :server, :passenger
set :use_sudo, false
set :user, :deploy
set :stages, %w(production staging)
set :keep_releases, 5

default_run_options[:pty] = true

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
  end
    
  namespace :delayed_job do 
    desc "Restart the delayed_job process"
    task :restart, :roles => :app do
      run "cd #{current_path}; RAILS_ENV=#{rails_env} bin/delayed_job restart"
    end
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

  after "deploy:restart", "deploy:delayed_job:restart"
  
end

require './config/boot'
