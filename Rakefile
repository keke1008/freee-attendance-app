# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task fmt: :environment do
  sh 'bundle exec rubocop -a'
  sh 'bundle exec erblint --lint-all -a'
end
