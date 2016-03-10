require 'logger'

module Log4Mos
  module Sinks
    class RubyLogger
      def initialize(logger)
        @logger = logger
      end

      def call(level, payload)
        @logger.send(level, payload)
      end
    end
  end
end
