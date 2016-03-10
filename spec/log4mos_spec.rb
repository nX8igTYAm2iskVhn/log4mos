require 'spec_helper'

require 'log4mos'

describe Log4Mos do
  describe '.register' do
    let(:logger) { Log4Mos::Logger.new }

    it 'registers a named logger' do
      Log4Mos.register(:test, logger)
      expect(Log4Mos.logger(:test)).to eql(logger)

      Log4Mos::Registry.unregister(:test)
    end

    it 'registers a default logger when no name is provided' do
      Log4Mos.register(logger)
      expect(Log4Mos.logger).to eql(logger)
      expect(Log4Mos.logger(:default)).to eql(logger)

      Log4Mos::Registry.unregister(:default)
    end
  end

  describe '.levels' do
    it 'returns supported logging levels' do
      expect(Log4Mos.levels).to eql [:debug, :info, :warn, :error, :fatal]
    end
  end

  describe '.level_applies?' do
    context 'with debug message level' do
      it 'returns true for logger level debug' do
        expect(Log4Mos.level_applies?(:debug, :debug)).to be_truthy
      end

      it 'returns false for logger level info' do
        expect(Log4Mos.level_applies?(:debug, :info)).to be_falsey
      end

      it 'returns false for logger level warn' do
        expect(Log4Mos.level_applies?(:debug, :warn)).to be_falsey
      end

      it 'returns false for logger level error' do
        expect(Log4Mos.level_applies?(:debug, :error)).to be_falsey
      end

      it 'returns false for logger level fatal' do
        expect(Log4Mos.level_applies?(:debug, :fatal)).to be_falsey
      end
    end

    context 'with info message level' do
      it 'returns true for logger level debug' do
        expect(Log4Mos.level_applies?(:info, :debug)).to be_truthy
      end

      it 'returns true for logger level info' do
        expect(Log4Mos.level_applies?(:info, :info)).to be_truthy
      end

      it 'returns false for logger level warn' do
        expect(Log4Mos.level_applies?(:info, :warn)).to be_falsey
      end

      it 'returns false for logger level error' do
        expect(Log4Mos.level_applies?(:info, :error)).to be_falsey
      end

      it 'returns false for logger level fatal' do
        expect(Log4Mos.level_applies?(:info, :fatal)).to be_falsey
      end
    end

    context 'with warn message level' do
      it 'returns true for logger level debug' do
        expect(Log4Mos.level_applies?(:warn, :debug)).to be_truthy
      end

      it 'returns true for logger level info' do
        expect(Log4Mos.level_applies?(:warn, :info)).to be_truthy
      end

      it 'returns true for logger level warn' do
        expect(Log4Mos.level_applies?(:warn, :warn)).to be_truthy
      end

      it 'returns false for logger level error' do
        expect(Log4Mos.level_applies?(:warn, :error)).to be_falsey
      end

      it 'returns false for logger level fatal' do
        expect(Log4Mos.level_applies?(:warn, :fatal)).to be_falsey
      end
    end

    context 'with error message level' do
      it 'returns true for logger level debug' do
        expect(Log4Mos.level_applies?(:error, :debug)).to be_truthy
      end

      it 'returns true for logger level info' do
        expect(Log4Mos.level_applies?(:error, :info)).to be_truthy
      end

      it 'returns true for logger level warn' do
        expect(Log4Mos.level_applies?(:error, :warn)).to be_truthy
      end

      it 'returns true for logger level error' do
        expect(Log4Mos.level_applies?(:error, :error)).to be_truthy
      end

      it 'returns false for logger level fatal' do
        expect(Log4Mos.level_applies?(:error, :fatal)).to be_falsey
      end
    end

    context 'with fatal message level' do
      it 'returns true for logger level debug' do
        expect(Log4Mos.level_applies?(:fatal, :debug)).to be_truthy
      end

      it 'returns true for logger level info' do
        expect(Log4Mos.level_applies?(:fatal, :info)).to be_truthy
      end

      it 'returns true for logger level warn' do
        expect(Log4Mos.level_applies?(:fatal, :warn)).to be_truthy
      end

      it 'returns true for logger level error' do
        expect(Log4Mos.level_applies?(:fatal, :error)).to be_truthy
      end

      it 'returns true for logger level fatal' do
        expect(Log4Mos.level_applies?(:fatal, :fatal)).to be_truthy
      end
    end
  end
end
