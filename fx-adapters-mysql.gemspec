# frozen_string_literal: true

require_relative "lib/fx/adapters/mysql/version"

Gem::Specification.new do |spec|
  spec.name = "fx-adapters-mysql"
  spec.version = Fx::Adapters::Mysql::VERSION
  spec.authors = ["Fabian Mersch"]
  spec.email = ["fabianmersch@gmail.com"]

  spec.summary = "MySQL adapter for fx"
  spec.homepage = "https://github.com/f-mer/fx-adapters-mysql"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "standard"

  spec.add_dependency "fx", "~> 0.6.2 "
end
