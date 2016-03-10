require 'spec_helper'

require 'stringio'

require 'log4mos'
require 'log4mos/sinks/splunk'
require 'log4mos/sinks/csv_formatter'

describe Log4Mos::Sinks::Splunk do
  let(:logger_output) { StringIO.new }
  let(:ruby_logger) { ::Logger.new(logger_output) }
  let(:splunk_sink) { Log4Mos::Sinks::Splunk.new(ruby_logger) }

  let(:logger) do
    logger = Log4Mos::Logger.new
    logger.sinks << splunk_sink
    logger
  end

  it 'logs JSON payload' do
    logger.info 'test', {test: :payload}
    output = JSON.parse(logger_output.string)

    expect(output['subtype']).to eql('test')
    expect(output['test']).to eql('payload')
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

  describe '#formatter=' do
    it 'changes the logger formatter' do
      splunk_sink.formatter = Log4Mos::Sinks::CsvFormatter
      logger.info 'test', {test: :payload}
      expect(logger_output.string).to include('test="payload"')
    end
  end
end
