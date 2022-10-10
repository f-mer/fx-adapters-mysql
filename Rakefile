# frozen_string_literal: true

load "spec/dummy/Rakefile"

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

task default: ["db:create", "spec", "standard:fix"]
