module Log4Mos
  module Filters
    class Chain

      def initialize(level, event_name, filters)
        @level = level
        @event_name = event_name
        @filters = filters || []
      end

      def filter(&block)
        @destination = block
        @chain = Array.new(@filters)

        self.next
      end

      def next
        next_filter = @chain.shift # get first filter
        if next_filter
          next_filter.call(self, @level, @event_name)
        else
          @destination.call
        end
      end
    end
  end
end
