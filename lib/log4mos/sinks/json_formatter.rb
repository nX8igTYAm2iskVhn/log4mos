require 'json'

module Log4Mos
  module Sinks
    class JsonFormatter
      def call(severity, time, progname, payload)
        begin
          "#{MultiJson.dump(payload)}\n" if payload
        rescue *errors_to_rescue => json_error
          # use backup strategy based on pos-service LogHelper

          data = {
            error_while_logging_message: json_error.message,
            error_while_logging: json_error.class.name }

          if payload.class.ancestors.include?(Exception)
            exception = payload
          elsif payload.is_a?(Hash)
            exception = payload[:exception]
          end

          if exception
            data[:exception_class] = exception.class.name
            data[:exception_message] = exception.message
            data[:exception_backtrace] = exception.backtrace if exception.backtrace
          end

          data
        end
      end

      private

      def errors_to_rescue
        errors = [SystemStackError, NoMemoryError]
        if RUBY_PLATFORM == "java"
          errors << Exception # workaround for https://github.com/jruby/jruby/issues/1099
        end
        errors
      end
    end
  end
end
