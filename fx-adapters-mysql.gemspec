# frozen_string_literal: true

require_relative "lib/fx/adapters/mysql/version"
version = Fx::Adapters::Mysql::VERSION

Gem::Specification.new do |spec|
  spec.authors = ["Fabian Mersch"]
  spec.email = ["fabianmersch@gmail.com"]
  spec.homepage = "https://github.com/f-mer/fx-adapters-mysql"
  spec.license = "MIT"
  spec.name = "fx-adapters-mysql"
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 2.1"
  spec.summary = "MySQL adapter for fx"
  spec.version = version

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE"]
  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/f-mer/fx-adapters-mysql/issues",
    "changelog_uri" => "https://github.com/f-mer/fx-adapters-mysql/blob/v#{version}/CHANGELOG.md",
    "source_code_uri" => "https://github.com/f-mer/fx-adapters-mysql/tree/v#{version}",
    "rubygems_mfa_required" => "true"
  }

  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_development_dependency "standard"

  spec.add_dependency "fx", "~> 0.7.0"
end
