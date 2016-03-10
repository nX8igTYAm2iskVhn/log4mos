require 'active_record/log_subscriber'

module Log4Mos
  module Rails
    class DatabaseRuntimeFilter
      def call(filter_chain, _, _)
        db_runtime_start = ActiveRecord::LogSubscriber.runtime
        return_value, editable_payload = filter_chain.next
        db_runtime = ActiveRecord::LogSubscriber.runtime - db_runtime_start
        editable_payload[:db_runtime] = db_runtime if db_runtime > 0

        return return_value, editable_payload
      end
    end
  end
end
