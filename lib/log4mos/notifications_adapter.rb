
module Log4Mos
  class NotificationsAdapter
    def initialize(logger, level = :info)
      @logger = logger
      @level = level
    end

    def instrument(event_name, payload, &block)
      @logger.send(level, event_name, payload, &block)
    end
  end
end
