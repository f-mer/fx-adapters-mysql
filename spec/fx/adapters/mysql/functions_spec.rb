require "spec_helper"

RSpec.describe Fx::Adapters::MySQL::Functions do
  describe ".all" do
    it "returns `Function` objects" do
      connection = ActiveRecord::Base.connection
      connection.execute <<-SQL.strip_heredoc
        CREATE FUNCTION test ()
        RETURNS TEXT DETERMINISTIC
        RETURN 'test';
      SQL

      functions = described_class.new(connection).all

      first = functions.first
      expect(functions.size).to eq 1
      expect(first.name).to eq "test"
      expect(first.definition).to eq <<-SQL.strip_heredoc.chomp
        DELIMITER $$
        CREATE FUNCTION `test`() RETURNS text CHARSET #{connection.charset}
            DETERMINISTIC
        RETURN 'test'$$
        DELIMITER ;
      SQL
    end
  end
end
