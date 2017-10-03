# config valid only for current version of Capistrano
lock "3.9.1"

set :application, "cadet_app"
set :repo_url, "ssh://git@bitbucket.org/pranav7/cadet-app.git"
set :user, 'rails'

# Default value for :format is :airbrussh.
# Airbrussh pretties up your SSHKit and Capistrano output
set :format, :airbrussh
# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
current_branch = `git symbolic-ref --short HEAD`.chomp
set :branch, ENV['branch'] || current_branch || "master"
# You can use the 'branch' parameter on deployment to specify the branch you wish to deploy

set :rvm_ruby_version, 'ruby-2.4.1'
set :pty, true
set :use_sudo, false
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :server do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  desc 'Start Puma Servers'
  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:stage) do
          execute "bundle exec puma --preload -b #{fetch(:puma_bind)}"
        end
      end
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Create production database"
  task :db_create do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :rake, 'db:create'
        end
      end
    end
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # invoke 'puma:restart'
    end
  end

  # before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
