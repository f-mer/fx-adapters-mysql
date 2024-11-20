module Fx
  module Adapters
    class MySQL
      # Fetches defined functions from the mysql connection.
      # @api private
      class Functions
        # Wraps #all as a static facade.
        #
        # @return [Array<Fx::Function>]
        def self.all(*args)
          new(*args).all
        end

        def initialize(connection)
          @connection = connection
        end

        # All of the functions that this connection has defined.
        #
        # @return [Array<Fx::Function>]
        def all
          functions_from_mysql.map { |function| to_fx_function(function) }
        end

        private

        attr_reader :connection

        def functions_from_mysql
          connection.exec_query(<<-SQL)
            SELECT
              ROUTINE_NAME AS name,
              ROUTINE_DEFINITION AS definition
            FROM INFORMATION_SCHEMA.ROUTINES
            WHERE ROUTINE_SCHEMA NOT IN ('sys', 'information_schema', 'mysql', 'performance_schema')
            AND ROUTINE_SCHEMA = '#{connection.current_database}'
            AND ROUTINE_TYPE = 'FUNCTION'
          SQL
        end

        def to_fx_function(result)
          name = result.fetch("name")
          definition = delete_definer(find_definition(name))
          Fx::Function.new(
            "name" => name,
            "definition" => definition
          )
        end

        def delete_definer(string)
          string.gsub(/ DEFINER=`[^`]+`@`[^`]+`/, "")
        end

        def find_definition(name)
          connection
            .exec_query("SHOW CREATE FUNCTION `#{name}`")
            .first
            .fetch("Create Function")
        end
      end
    end
  end
end
