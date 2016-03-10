class TestSink
  attr_reader :level, :payload
  def call(level, payload)
    @level, @payload = level, payload
  end
end
