require 'pry'
require 'spec_helper'

require 'log4mos'
require 'log4mos/sinks/json_formatter'
require 'active_record'

describe Log4Mos::Sinks::JsonFormatter do
  class TestObject
    def initialize(foo)
      @foo = foo
    end
  end

  class TestException < Exception
    def initialize(foo)
      @foo = foo
    end
  end
  subject { Log4Mos::Sinks::JsonFormatter.new.call(nil, nil, nil, loggable_object) }

  context "when logging an ActiveRecord object" do
    let(:loggable_object) {
      class BadTestObject < ActiveRecord::Base
        attr_accessor :foo

        def initialize
          @foo = 1
        end
      end
    }

    it "does not throw key error" do
      expect { subject }.to_not raise_error
    end
  end

  context "when logging a plain object" do
    let(:loggable_object) { TestObject.new("hi") }
    it "ends with a linebreak so that splunk forwarder does not contatenate log lines" do
      expect(subject).to end_with("\n")
      expect(subject).to eq "{\"foo\":\"hi\"}\n"
    end
  end

  context "when jsoning an object nested deeper than MultiJson can handle" do
    subject { Log4Mos::Sinks::JsonFormatter.new.call(nil, nil, nil, very_deep_object(klass)) }

    context "with non-exception test object" do
      let(:klass) { TestObject }
      let(:expected_error_info) {
        if RUBY_PLATFORM == "java"
          { :error_while_logging_message=>"",
            :error_while_logging=>"Java::JavaLang::StackOverflowError"}
        else
          { :error_while_logging_message=>"stack level too deep",
            :error_while_logging=>"SystemStackError"}
        end
      }

      it "does not throw an error" do
        expect { subject }.to_not raise_error
      end

      it "returns as much information as it can" do
        expect(subject).to eq expected_error_info
      end
    end

    context "with exception" do
      let(:klass) { TestException }
      let(:expected_error_info) {
        if RUBY_PLATFORM == "java"
          { :error_while_logging_message=>"",
            :error_while_logging=>"Java::JavaLang::StackOverflowError",
            :exception_class=>"TestException",
            :exception_message=>"TestException"}
        else
          { :error_while_logging_message=>"stack level too deep",
            :error_while_logging=>"SystemStackError",
            :exception_class=>"TestException",
            :exception_message=>"TestException"}
        end
      }

      it "does not throw an error" do
        expect { subject }.to_not raise_error
      end

      it "returns as much information as it can" do
        expect(subject).to eq(expected_error_info)
      end

      context "with hash containing exception" do
        let(:klass) { TestException }
        let(:payload) { { exception: very_deep_object(klass) } }
        it "returns as much information as it can" do
          result =  Log4Mos::Sinks::JsonFormatter.new.call(nil, nil, nil, payload)
          expect(result).to eq(expected_error_info)
        end
      end
    end

    def very_deep_object(klass)
      ob = klass.new("foo")
      0.upto(10001).each do |i|
        ob = klass.new(ob)
      end
      ob
    end
  end
end
