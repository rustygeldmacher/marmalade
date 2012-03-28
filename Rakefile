#!/usr/bin/env rake
require 'rake'
require 'rspec'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

desc 'Default: run the specs'
task :default => 'spec'

desc "Run specs"
RSpec::Core::RakeTask.new('spec') do |t|
   t.pattern = 'spec/**/*_spec.rb'
end
