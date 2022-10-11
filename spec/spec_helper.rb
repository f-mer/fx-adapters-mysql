# frozen_string_literal: true

require_relative "dummy/config/environment"

require "fx/adapters/mysql"

ENV["RAILS_ENV"] = "test"

Fx.configure do |config|
  config.database = Fx::Adapters::MySQL.new
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = "random"

  config.before(:each) do
    ActiveRecord::Base.connection.execute "DROP DATABASE IF EXISTS dummy_test"
    ActiveRecord::Base.connection.execute "CREATE DATABASE dummy_test"
    ActiveRecord::Base.connection.execute "USE dummy_test"
  end
end
