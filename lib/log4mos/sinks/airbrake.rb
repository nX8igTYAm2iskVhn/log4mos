require 'airbrake'

module Log4Mos
  module Sinks
    class Airbrake
      def initialize(level = :error)
        @notification_level = level
      end

      def call(level, payload)
        ::Airbrake.notify_or_ignore(payload[:exception]) if payload[:exception] && applies?(level)
      end

      private

      def applies?(event_level)
        Log4Mos.level_applies?(event_level, @notification_level)
      end
    end
  end
end
