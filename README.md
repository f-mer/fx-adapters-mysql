# Fx::Adapters::Mysql

MySQL adapter for [fx](https://github.com/teoljungberg/fx).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fx-adapters-mysql'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fx-adapters-mysql

## Usage

```rb
#  config/initializers/fx.rb

Fx.configure do |config|
 config.database = Fx::Adapters::MySQL.new
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rake` to call the default task that creates test db, run specs and `standard:fix` linter task. For custom database connection configuration use `DATABASE_URL` environment variable `export DATABASE_URL="$(ruby -e 'require "cgi"; puts "mysql2://db_username:#{CGI.escape("password,with special characters.")}@hostname/dummy_test"')"` and run commands (`bin/rspec`, `bin/setup`, etc).  You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Docker environment

Installed Docker with BuildKit support and docker-compose are required.

To run specs in docker use `docker-compose up --abort-on-container-exit`. If you need to support different version of MySQL you can specify docker-compose arguments `--build-args MYSQL_VERSION=2-1.2`. To run tests in other versions, build with `docker-compose build --build-arg RUBY_VERSION="3.0.4" --build-arg DEBIAN_CODENAME="buster" --build-arg UID="1001" --build-arg GID="1001"`, re-build it `docker-compose build --no-cache`. All the build arguments can be used in conjunction.

Development environment can be started with `docker-compose run test bash` then run `bin/setup` and `bin/rake` or `bin/rspec`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/f-mer/fx-adapters-mysql.
