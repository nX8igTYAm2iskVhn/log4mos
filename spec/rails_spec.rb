require 'spec_helper'

require 'rails'
require 'ostruct'
require 'fileutils'

require 'log4mos'

describe 'Log4Mos::Rails' do
  before do
    Rails.application = OpenStruct.new(config: {})
    Rails.application.config = OpenStruct.new(root: Pathname.new('.'), filter_parameters: [:password], log_level: :info)

    # creates log folder
    FileUtils.mkdir_p('./log')
  end

  it 'sets up a default logger' do
    require 'log4mos/rails'

    expect(Log4Mos.logger).not_to be_nil

    splunk_sink = Log4Mos.logger.sinks[0]
    expect(splunk_sink).to be_an_instance_of Log4Mos::Sinks::Splunk
    expect(splunk_sink.logger.info?).to be_truthy
    expect(splunk_sink.logger.debug?).to be_falsey
    expect(Log4Mos.logger.sinks[1]).to be_an_instance_of Log4Mos::Sinks::Airbrake

    expect(Log4Mos.logger.filters[0]).to be_an_instance_of Log4Mos::Rails::DatabaseRuntimeFilter
    expect(Log4Mos.logger.filters[1]).to be_an_instance_of Log4Mos::Filters::RequestContext
    expect(Log4Mos.logger.filters[2]).to be_an_instance_of Log4Mos::Filters::ParametersFilter

    subscriber = ActiveSupport::LogSubscriber.log_subscribers.last
    expect(subscriber).to be_an_instance_of Log4Mos::Notifications::Subscriber
    expect(subscriber).to respond_to(:process_action)
  end

  after do
    Log4Mos::Registry.unregister(:default)
  end
end
