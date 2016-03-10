module Log4Mos
  module Sinks
    class CsvFormatter
      def call(severity, time, progname, payload)
        format(payload) + "\n" if payload
      end

      private

      # Assumes there's never a circular reference
      def format(payload)
        payload.map do |key, value|
          if key.to_s == 'context' && value.is_a?(Hash)
            format(value)
          else
            %{#{key}="#{value}"}
          end
        end.join(',')
      end
    end
  end
end
