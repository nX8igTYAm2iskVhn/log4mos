require 'rails'
require 'logger'

require 'log4mos'
require 'log4mos/sinks/splunk'
Log4Mos.optional_require 'log4mos/sinks/airbrake'
Log4Mos.optional_require 'log4mos/filters/request_context'

require 'log4mos/notifications'
Log4Mos.optional_require 'log4mos/rails/database_runtime_filter'
require 'log4mos/filters/parameters_filter'

module Log4Mos
  module Rails
    def self.setup!
      ruby_logger = ::Logger.new(::Rails.root.join('log').join('splunk.log'))
      if ::Rails.application
        ruby_logger.level = ::Logger.const_get(::Rails.application.config.log_level.to_s.upcase)
      else
        ruby_logger.level = ::Logger::INFO
      end

      logger = Log4Mos::Logger.new
      logger.sinks << Sinks::Splunk.new(ruby_logger)
      logger.sinks << Sinks::Airbrake.new if defined? Sinks::Airbrake

      logger.filters << DatabaseRuntimeFilter.new if defined? DatabaseRuntimeFilter
      logger.filters << Filters::RequestContext.new if defined? Filters::RequestContext
      if ::Rails.application
        logger.filters << Filters::ParametersFilter.new(::Rails.application.config.filter_parameters)
      end

      Log4Mos.register(logger)

      Notifications.subscribe_to(:process_action, :action_controller)
      # Log4Mos::Notifications.subscribe_to(:sql, :active_record)
    end

    self.setup!
  end
end
