require "spec_helper"

RSpec.describe Fx::Adapters::MySQL::Triggers do
  describe ".all" do
    it "returns `Trigger` objects" do
      connection = ActiveRecord::Base.connection
      connection.execute <<-SQL.strip_heredoc
        CREATE TABLE users (
            id int PRIMARY KEY,
            name varchar(256),
            upper_name varchar(256)
        );
      SQL
      connection.execute <<-SQL.strip_heredoc
        CREATE FUNCTION uppercase_users_name (s CHAR)
        RETURNS CHAR DETERMINISTIC
        RETURN UPPER(s);
      SQL
      connection.execute <<-SQL.strip_heredoc
        CREATE TRIGGER uppercase_users_name
            BEFORE INSERT ON users
            FOR EACH ROW
            SET NEW.name = uppercase_users_name(NEW.name);
      SQL

      triggers = described_class.new(connection).all

      first = triggers.first
      expect(triggers.size).to eq 1
      expect(first.name).to eq "uppercase_users_name"
      expect(first.definition).to include("BEFORE INSERT")
      expect(first.definition).to match(/ON users/)
      expect(first.definition).to include("FOR EACH ROW")
      expect(first.definition).to include("SET NEW.name = uppercase_users_name(NEW.name)")
    end
  end
end
