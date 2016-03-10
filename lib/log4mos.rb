module Log4Mos
  def self.logger(name = :default)
    Registry[name]
  end

  def self.register(name = :default, logger)
    Registry.register(name, logger)
  end

  def self.levels
    [:debug, :info, :warn, :error, :fatal].freeze
  end

  def self.level_applies?(message_level, logger_level)
    Log4Mos::levels.index(message_level) >= Log4Mos::levels.index(logger_level)
  end

  # Helper method

  def self.optional_require(path)
    require path
  rescue LoadError
    # just ignore
  end
end

require 'log4mos/logger'
require 'log4mos/registry'
