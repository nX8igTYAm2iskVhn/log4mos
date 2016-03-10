require 'singleton'

module Log4Mos
  class Registry
    include Singleton
    class << self
      private :instance
    end

    def self.[](key)
      instance.loggers[key.to_s]
    end

    def self.register(key, logger)
      instance.loggers[key.to_s] = logger
    end

    def self.unregister(key)
      instance.loggers.delete(key.to_s)
    end

    attr_reader :loggers

    def initialize
      @loggers = {}
    end
  end
end
