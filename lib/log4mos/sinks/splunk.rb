require 'logger'

require 'log4mos/sinks/ruby_logger'
require 'log4mos/sinks/json_formatter'

module Log4Mos
  module Sinks
    class Splunk

      attr_reader :logger

      def initialize(logger, formatter = nil)
        logger.formatter = create_formatter(formatter)
        @logger_sink = Sinks::RubyLogger.new(logger)
        @logger = logger
      end

      def call(level, payload)
        @logger_sink.call(level, payload)
      end

      def formatter=(formatter)
        @logger.formatter = create_formatter(formatter)
      end

      private

      def create_formatter(formatter)
        if formatter.nil?
          JsonFormatter.new
        elsif formatter.is_a? Class
          formatter.new
        elsif formatter.respond_to? :call
          formatter
        else
          raise ArgumentError, "Invalid formatter type. Expected a Class or a callable, but got: #{formatter}"
        end
      end
    end
  end
end
