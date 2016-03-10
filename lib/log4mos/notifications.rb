require 'active_support/log_subscriber'

module Log4Mos
  # Module for integrating with ActiveSupport::Notifications generated events
  module Notifications

    def self.subscribe_to(event_name, namespace, options = {})
      logger = options[:logger] || Log4Mos.logger
      level = options[:level] || :info
      subscribe(event_name, namespace) do |event|
        logger.send(level, event.name, event.payload.merge(duration: event.duration))
      end
    end

    private

    def self.subscribe(event_name, namespace, &block)
      subscriber = Subscriber.new
      define_method_for_event(subscriber, event_name, &block)
      ActiveSupport::LogSubscriber.attach_to(namespace, subscriber)
    end

    def self.define_method_for_event(subscriber, event_name, &block)
      unless subscriber.respond_to? event_name
        (class << subscriber; self end).class_eval do
          define_method(event_name, &block)
        end
      end
    end

    class Subscriber < ActiveSupport::LogSubscriber
    end
  end
end
