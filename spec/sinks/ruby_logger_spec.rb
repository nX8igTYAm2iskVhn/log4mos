require 'spec_helper'

require 'stringio'

require 'log4mos'
require 'log4mos/sinks/ruby_logger'

describe Log4Mos::Sinks::RubyLogger do
  let(:logger_output) { StringIO.new }
  let(:ruby_logger) { ::Logger.new(logger_output) }
  let(:ruby_logger_sink) { Log4Mos::Sinks::RubyLogger.new(ruby_logger) }
  let(:logger) do
    logger = Log4Mos::Logger.new
    logger.sinks << ruby_logger_sink
    logger
  end

  it 'logs payload to ruby logger' do
    logger.info 'test', {test: :payload}

    expect(logger_output.string).to include(':subtype=>"test"', ':test=>:payload')
  end

  context 'with logger level set to info' do
    let(:ruby_logger) do
      ruby_logger = ::Logger.new(logger_output)
      ruby_logger.level = ::Logger::INFO

      ruby_logger
    end

    it 'does not output debug messages' do
      logger.debug 'test', {test: :payload}

      expect(logger_output.string).to be_empty
    end
  end
end
