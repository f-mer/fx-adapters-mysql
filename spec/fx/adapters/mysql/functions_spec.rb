require "spec_helper"

RSpec.describe Fx::Adapters::MySQL::Functions do
  describe ".all" do
    it "returns `Function` objects" do
      connection = ActiveRecord::Base.connection
      connection.execute <<-EOS.strip_heredoc
        CREATE FUNCTION test ()
        RETURNS TEXT DETERMINISTIC
        RETURN 'test';
      EOS

      functions = described_class.new(connection).all

      first = functions.first
      expect(functions.size).to eq 1
      expect(first.name).to eq "test"
      expect(first.definition).to eq <<-EOS.strip_heredoc.chomp
        DELIMITER $$
        CREATE FUNCTION `test`() RETURNS text CHARSET utf8mb4
            DETERMINISTIC
        RETURN 'test'$$
        DELIMITER ;
      EOS
    end
  end
end
