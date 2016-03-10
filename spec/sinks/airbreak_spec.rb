require 'spec_helper'

require 'log4mos'
require 'log4mos/sinks/airbrake'

describe Log4Mos::Sinks::Airbrake do
  let(:airbrake_sink) { Log4Mos::Sinks::Airbrake.new }
  let(:logger) do
    logger = Log4Mos::Logger.new
    logger.sinks << airbrake_sink
    logger
  end

  it 'notifies airbrake when exception is present in payload' do
    exception = RuntimeError.new
    expect(Airbrake).to receive(:notify_or_ignore).with(exception)

    logger.error 'error', {exception: exception}
  end

  it 'notifies airbrake if message level is greater than error' do
    exception = RuntimeError.new
    expect(Airbrake).to receive(:notify_or_ignore).with(exception)

    logger.fatal 'error', {exception: exception}
  end

  it 'does not notify airbrake if message level is smaller than error' do
    expect(Airbrake).not_to receive(:notify_or_ignore)

    logger.info 'error', {exception: RuntimeError.new}
  end

  it 'does not notify airbrake if exception is not present in payload' do
    expect(Airbrake).not_to receive(:notify_or_ignore)

    logger.error 'error', {message: :some_error}
  end

  context 'with a sink level set to debug' do
    let(:airbrake_sink) { Log4Mos::Sinks::Airbrake.new(:debug) }

    Log4Mos.levels.each do |level|
      it "notifies airbrake if message level is #{level}" do
        exception = RuntimeError.new
        expect(Airbrake).to receive(:notify_or_ignore).with(exception)

        logger.send(level, 'error', {exception: exception})
      end
    end
  end
end
