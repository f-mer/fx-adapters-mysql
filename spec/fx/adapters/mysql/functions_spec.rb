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

      connection.execute <<-EOS.strip_heredoc
        CREATE FUNCTION test2 (input_param INT)
        RETURNS INT DETERMINISTIC
        BEGIN
          RETURN input_param*2;
        END;
      EOS

      functions = described_class.new(connection).all

      test_function = functions.first
      expect(functions.size).to eq 2
      expect(test_function.name).to eq "test"
      expect(test_function.definition).to eq <<-EOS.strip_heredoc.chomp
        DELIMITER $$
        CREATE FUNCTION `test`() RETURNS text CHARSET #{connection.charset}
            DETERMINISTIC
        RETURN 'test'$$
        DELIMITER ;
      EOS

      test2_function = functions.last
      expect(functions.size).to eq 2
      expect(test2_function.name).to eq "test2"
      expect(test2_function.definition).to eq <<-EOS.strip_heredoc.chomp
        DELIMITER $$
        CREATE FUNCTION `test2`(input_param INT) RETURNS int(11)
            DETERMINISTIC
        BEGIN
          RETURN input_param*2;
        END$$
        DELIMITER ;
      EOS
    end
  end
end
