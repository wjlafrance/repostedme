#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Repostedme::Application.load_tasks

namespace :cleanup do
  task :users => :environment do |t|
    User.all.each do |u|
      u.delete if u.created_at > 14.days.ago
    end
  end
end
