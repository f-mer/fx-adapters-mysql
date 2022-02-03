# frozen_string_literal: true

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load("rails/tasks/engine.rake")

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

task default: ["db:create", "spec", "standard"]
