require 'request_context'
require 'log4mos/filters/payload_filter'

module Log4Mos
  module Filters
    class RequestContext
      include PayloadFilter

      def filter(editable_payload, level, event_name)
        if ::RequestContext.current.respond_to? :to_hash
          context = ::RequestContext.current.to_hash
          return editable_payload.merge(context: context) unless context.empty?
        end
        editable_payload
      end
    end
  end
end
