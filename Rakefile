require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :db do
  desc 'migrate your database'
  task :migrate do
    require 'bundler'
    Bundler.require
    require './lib/application.rb'
    ActiveRecord::Migrator.migrate('db/migrate')
  end
end