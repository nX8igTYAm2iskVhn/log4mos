require 'log4mos/filters/chain'

module Log4Mos
  class Logger
    attr_accessor :sinks, :filters

    def initialize
      @sinks = []
      @filters = []
      @filters_for_event = {}
    end

    Log4Mos::levels.each do |level|
      define_method level do |event_name, client_payload = nil, &block|
        log(level, event_name, client_payload, caller[0], &block)
      end
    end

    def filters_for_event(event_name)
      @filters_for_event[event_name.to_s] ||= []
    end

    private

    def log(level, event_name, client_payload = nil, caller, &block)
      execution_timestamp = Time.now
      client_payload ||= {}
      duration_data = {}

      return_value = nil
      execution_error = nil
      _, filtered_payload = build_filter_chain(level, event_name).filter do
        if block
          begin
            return_value = timed_execute(duration_data) do
              block.call(client_payload)
            end
          # Catching Exception since we want to be able to log any type of errors,
          # even unexpected ones, like Memory or Script Errors
          rescue Exception => e
            execution_error = e
            exception_payload = {exception: execution_error, backtrace: execution_error.backtrace}
          end
        end
        [return_value, client_payload.merge(exception_payload || {})]
      end

      log_data = generate_log_data(execution_timestamp, level, caller, filtered_payload, duration_data)
      log_data.merge!(subtype: event_name)
      output_data(level, log_data)

      if execution_error 
        raise execution_error 
      else
        return_value
      end
    end

    private

    def timed_execute(duration_data)
      duration_data[:start_time] = Time.now.to_f
      return yield
    ensure
      duration_data[:end_time] = Time.now.to_f
      duration_data[:duration] = (duration_data[:end_time] - duration_data[:start_time]) * 1000.0
    end

    def build_filter_chain(level, event_name)
      filters = @filters + (@filters_for_event[event_name] || [])

      Filters::Chain.new(level, event_name, filters)
    end

    def generate_log_data(time_stamp, level, caller, payload, duration_payload = nil)
      log_data = {time: time_stamp, level: level, caller: caller}
      log_data.merge!(payload)
      log_data.merge!(duration_payload) if duration_payload

      log_data
    end

    def output_data(level, log_data)
      @sinks.each { |sink| sink.call(level, log_data) }
    rescue => error
      $stderr.puts "Error outputing data: #{error}\n#{error.backtrace.join('\n')}"
    end
  end
end
