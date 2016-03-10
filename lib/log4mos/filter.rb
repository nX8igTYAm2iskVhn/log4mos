module Log4Mos
  class Filter
    def call(chain, level, event_name)
      chain.next
    end
  end
end
