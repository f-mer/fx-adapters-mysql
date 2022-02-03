module Fx
  module Adapters
    class MySQL
      # Fetches defined triggers from the mysql connection.
      # @api private
      class Triggers
        # Wraps #all as a static facade.
        #
        # @return [Array<Fx::Adapters::MySQL::Trigger>]
        def self.all(*args)
          new(*args).all
        end

        def initialize(connection)
          @connection = connection
        end

        # All of the triggers that this connection has defined.
        #
        # @return [Array<Fx::Trigger>]
        def all
          triggers_from_mysql.map { |trigger| to_fx_trigger(trigger) }
        end

        private

        attr_reader :connection

        def triggers_from_mysql
          connection.exec_query(<<-SQL)
            SELECT
              TRIGGER_NAME AS name,
              ACTION_STATEMENT AS definition,
              EVENT_MANIPULATION AS event,
              EVENT_OBJECT_TABLE AS table_name,
              ACTION_TIMING AS timing
            FROM INFORMATION_SCHEMA.TRIGGERS
            WHERE TRIGGER_SCHEMA = '#{connection.current_database}'
          SQL
        end

        def to_fx_trigger(result)
          name = result.fetch("name")
          definition = <<~SQL
            CREATE TRIGGER #{name} #{result.fetch("timing")} #{result.fetch("event")} ON #{result.fetch("table_name")}
            FOR EACH ROW
            #{result.fetch("definition")}
          SQL
          Fx::Trigger.new(
            "name" => name,
            "definition" => definition
          )
        end
      end
    end
  end
end
