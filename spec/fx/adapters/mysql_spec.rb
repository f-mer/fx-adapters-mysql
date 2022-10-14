require "spec_helper"

RSpec.describe Fx::Adapters::MySQL do
  subject(:adapter) { described_class.new }
  let(:connection) { ActiveRecord::Base.connection }

  describe "#create_function" do
    it "successfully creates a function" do
      adapter.create_function(
        <<-EOS
          CREATE FUNCTION test ()
          RETURNS TEXT DETERMINISTIC
          RETURN 'test';
        EOS
      )

      expect(adapter.functions.map(&:name)).to include("test")
    end
  end

  describe "#create_trigger" do
    after { connection.execute "DROP TABLE users;" }

    it "successfully creates a trigger" do
      connection.execute <<-EOS
        CREATE TABLE users (
            id int PRIMARY KEY,
            name varchar(256),
            upper_name varchar(256)
        );
      EOS
      adapter.create_function <<-EOS
        CREATE FUNCTION uppercase_users_name (s CHAR)
        RETURNS CHAR DETERMINISTIC
        RETURN UPPER(s);
      EOS
      adapter.create_trigger(
        <<-EOS
          CREATE TRIGGER uppercase_users_name
              BEFORE INSERT ON users
              FOR EACH ROW
              SET NEW.name = uppercase_users_name(NEW.name);
        EOS
      )

      expect(adapter.triggers.map(&:name)).to include("uppercase_users_name")
    end
  end

  describe "#drop_function" do
    context "when the function has arguments" do
      it "successfully drops a function with the entire function signature" do
        adapter.create_function(
          <<-EOS
            CREATE FUNCTION adder (x INT, y INT)
            RETURNS INT DETERMINISTIC
            RETURN x + y;
          EOS
        )

        adapter.drop_function(:adder)

        expect(adapter.functions.map(&:name)).not_to include("adder")
      end
    end

    context "when the function does not have arguments" do
      it "successfully drops a function" do
        adapter.create_function(
          <<-EOS
            CREATE FUNCTION test()
            RETURNS TEXT DETERMINISTIC
            RETURN 'test';
          EOS
        )

        adapter.drop_function(:test)

        expect(adapter.functions.map(&:name)).not_to include("test")
      end
    end
  end

  describe "#drop_trigger" do
    after { connection.execute "DROP TABLE users;" }

    it "successfully drops a trigger" do
      connection.execute <<-EOS
        CREATE TABLE users (
            id int PRIMARY KEY,
            name varchar(256),
            upper_name varchar(256)
        );
      EOS
      adapter.create_function <<-EOS
        CREATE FUNCTION uppercase_users_name (s CHAR)
        RETURNS CHAR DETERMINISTIC
        RETURN UPPER(s);
      EOS
      adapter.create_trigger(
        <<-EOS
          CREATE TRIGGER uppercase_users_name
              BEFORE INSERT ON users
              FOR EACH ROW
              SET NEW.name = uppercase_users_name(NEW.name);
        EOS
      )
      adapter.drop_trigger(:uppercase_users_name)

      expect(adapter.triggers.map(&:name)).not_to include("uppercase_users_name")
    end
  end

  describe "#functions" do
    it "finds functions and builds Fx::Function objects" do
      adapter.create_function(
        <<-EOS
          CREATE FUNCTION test ()
          RETURNS TEXT DETERMINISTIC
          RETURN 'test';
        EOS
      )

      expect(adapter.functions.map(&:name)).to eq ["test"]
    end
  end

  describe "#triggers" do
    after { connection.execute "DROP TABLE users;" }

    it "finds triggers and builds Fx::Trigger objects" do
      connection.execute <<-EOS
        CREATE TABLE users (
            id int PRIMARY KEY,
            name varchar(256),
            upper_name varchar(256)
        );
      EOS
      adapter.create_function <<-EOS
        CREATE FUNCTION uppercase_users_name (s CHAR)
        RETURNS CHAR DETERMINISTIC
        RETURN UPPER(s);
      EOS
      sql_definition = <<-EOS
        CREATE TRIGGER uppercase_users_name
            BEFORE INSERT ON users
            FOR EACH ROW
            SET NEW.name = uppercase_users_name(NEW.name);
      EOS
      adapter.create_trigger(sql_definition)

      expect(adapter.triggers.map(&:name)).to eq ["uppercase_users_name"]
    end
  end
end
