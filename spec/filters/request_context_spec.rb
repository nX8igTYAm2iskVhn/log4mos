require 'spec_helper'
require 'support/test_sink'

require 'log4mos'
require 'log4mos/filters/request_context'

require 'securerandom'

describe Log4Mos::Filters::RequestContext do
  let(:filter) { Log4Mos::Filters::RequestContext.new }
  let(:test_sink) { TestSink.new }
  let(:logger) do
    logger = Log4Mos::Logger.new
    logger.sinks << test_sink
    logger.filters << filter

    logger
  end

  let(:current_context) { ::RequestContext.context_class.new }
  around do |test|
    RequestContext.current = current_context
    current_context.request_id = SecureRandom.uuid
    current_context.user_email = 'test@log4mos.org'
    test.call
    RequestContext.current = nil
  end

  it 'adds the current context to the log payload' do
    client_payload = {payload: :value}.freeze
    logger.info 'spec', client_payload
    expect(test_sink.payload[:context]).to eql(current_context.to_hash)
  end
end
