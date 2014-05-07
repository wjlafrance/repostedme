# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'repostedme'
set :repo_url, 'git@github.com:wjlafrance/repostedme.git'

set :linked_dirs, %w{tmp log}

server 'reposted.me', user: 'william', roles: %w{web, app, db}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:all), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Fix permissions'
  task :fix_permissions do
    on roles(:all), in: :sequence, wait: 5 do
      execute "chmod -R g+rw #{release_path}"
      execute "sudo chown -R root:admin #{release_path}"
    end
  end

  desc 'Precompile assets'
  task :assets do
    on roles(:all), in: :sequence, wait: 5 do
      execute "cd #{release_path} && bundle exec rake assets:precompile"
    end
  end

  after "deploy:symlink:release", :fix_permissions

  after "deploy:symlink:release", :assets

  after :publishing, :restart

end
