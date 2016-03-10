require 'spec_helper'
require 'support/test_sink'

require 'log4mos'
require 'log4mos/filters/payload_filter'

require 'timecop'
require 'securerandom'

describe Log4Mos::Logger do
  let(:test_sink) { TestSink.new }
  let(:logger) do
    logger = Log4Mos::Logger.new
    logger.sinks << test_sink

    logger
  end

  let(:event_name) { 'some_event' }
  let(:payload) { {a: 1, b: 2} }

  it 'logs payload' do
    logger.info event_name, payload
    expect(test_sink.payload).to include(payload)
  end

  it 'adds the level to logged payload' do
    logger.debug event_name, payload
    expect(test_sink.payload[:level]).to eql(:debug)

    logger.info event_name, payload
    expect(test_sink.payload[:level]).to eql(:info)

    logger.warn event_name, payload
    expect(test_sink.payload[:level]).to eql(:warn)

    logger.error event_name, payload
    expect(test_sink.payload[:level]).to eql(:error)

    logger.fatal event_name, payload
    expect(test_sink.payload[:level]).to eql(:fatal)
  end

  it 'adds subtype to logged payload' do
    logger.info event_name, payload
    expect(test_sink.payload[:subtype]).to eql(event_name)
  end

  it 'adds timestamp to logged payload' do
    expected_time = Time.now
    Timecop.freeze(expected_time) do
      logger.info event_name, payload
    end
    expect(test_sink.payload[:time]).to be_within(1).of(expected_time)
  end

  it 'adds timestamp to logged payload' do
    expected_time = Time.now
    Timecop.freeze(expected_time) do
      logger.info event_name, payload
    end
    expect(test_sink.payload[:time]).to be_within(1).of(expected_time) # one second
  end

  context 'with block given' do
    it 'returns the values returned from the block' do
      return_value = logger.info event_name, payload do
        1 + 1
      end
      expect(return_value).to eql(2)
    end

    it 'adds duration to payload' do
      logger.info event_name, payload do
        sleep(1)
      end
      expect(test_sink.payload[:duration]).to be >= 1000
    end

    it 'adds start time to payload' do
      logger.info event_name, payload do
        1 + 1
      end

      expect(test_sink.payload[:start_time]).not_to be_nil
    end

    it 'adds end time to payload' do
      logger.info event_name, payload do
        1 * 1
      end

      expect(test_sink.payload[:end_time]).not_to be_nil
    end

    it 'adds exception information in case of error' do
      expect{
        logger.info event_name, payload do
          raise Exception
        end
      }.to raise_error(Exception)
      expect(test_sink.payload[:exception]).to be_instance_of(Exception)
      expect(test_sink.payload[:backtrace]).not_to be_nil
    end
  end

  context 'with global filters' do
    before do
      logger.filters << Log4Mos::Filters::PayloadFilter.create do |editable_payload, _, _|
        editable_payload[:special_value] = 'special'

        editable_payload
      end
    end

    it 'applies filter to all events' do
      logger.info 'some_event', {}
      expect(test_sink.payload).to have_key(:special_value)

      logger.info '', {}
      expect(test_sink.payload).to have_key(:special_value)

      logger.info "event-#{SecureRandom.uuid}", {}
      expect(test_sink.payload).to have_key(:special_value)
    end
  end

  context 'with scoped filters' do
    before do
      logger.filters_for_event('specific_event') << Log4Mos::Filters::PayloadFilter.create do |editable_payload, _, _|
        editable_payload[:special_value] = 'special'

        editable_payload
      end
    end

    it 'applies filter only to specific event' do
      logger.info 'specific_event', {}
      expect(test_sink.payload).to have_key(:special_value)

      logger.info "event-#{SecureRandom.uuid}", {}
      expect(test_sink.payload).not_to have_key(:special_value)
    end
  end
end
