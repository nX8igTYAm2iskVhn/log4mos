module Log4Mos
  module Filters
    module PayloadFilter
      def call(chain, level, event_name)
        return_value, editable_payload = chain.next

        return return_value, filter(editable_payload, level, event_name)
      end

      # Process the given payload and return it
      def filter(editable_payload, level, event_name)
        raise NotImplementedError,
              'You must implement the method filter(editable_payload, level, event_name)'
      end

      def self.create(&filter_block)
        Class.new do
          include PayloadFilter
          define_method(:filter, &filter_block)
        end.new
      end
    end
  end
end
