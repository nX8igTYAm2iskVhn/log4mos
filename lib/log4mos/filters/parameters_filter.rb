require 'log4mos/filters/payload_filter'

module Log4Mos
  module Filters

    # Filter for obfuscating all given parameters from log payloads
    class ParametersFilter
      include Filters::PayloadFilter

      def initialize(parameters)
        @filtered_parameters = {}
        # converts array to a hash so access by key is faster
        parameters.inject(@filtered_parameters) do |hash, parameter|
          hash[parameter.to_s] = true
          hash
        end
      end

      def filter(editable_payload, level, event_name)
        clear_filtered_parameters(editable_payload)
      end

      private
      def clear_filtered_parameters(payload)
        payload.each do |key, _|
          if @filtered_parameters[key.to_s]
            payload[key] = '[FILTERED]'
          else
            clear_filtered_parameters(payload[key]) if payload[key].is_a? Hash
          end
        end

        payload
      end
    end
  end
end
