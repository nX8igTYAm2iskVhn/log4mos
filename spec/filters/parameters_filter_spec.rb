require 'spec_helper'
require 'support/test_sink'

require 'log4mos'
require 'log4mos/filters/parameters_filter'

describe Log4Mos::Filters::ParametersFilter do
  let(:parameters) { [:password] }
  let(:filter) { Log4Mos::Filters::ParametersFilter.new(parameters)}
  let(:test_sink) { TestSink.new }
  let(:logger) do
    logger = Log4Mos::Logger.new
    logger.sinks << test_sink
    logger.filters << filter

    logger
  end

  it 'keeps client payload untouched' do
    client_payload = {password: 'password'}.freeze
    logger.info 'spec', client_payload
    expect(client_payload[:password]).to eql('password')
  end

  it 'filters parameters from logged payload' do
    logger.info 'spec', password: 'password'
    expect(test_sink.payload[:password]).to eql('[FILTERED]')
  end


  it 'filters parameters nested in payload' do
    client_payload = {value: {value: {value: {value: {value: {password: 'password'}}}}}}.freeze
    logger.info 'spec', client_payload
    expect(test_sink.payload[:value][:value][:value][:value][:value][:password]).to eql('[FILTERED]')
  end
end
