require "big"

struct Mollie
  struct Amount
    getter :value, :currency

    def initialize(value : Float64 | Int32 | String, @currency : String)
      self.value = value
    end

    def value=(value : Float64 | Int32 | String)
      @value = BigDecimal.new(value.to_s)
    end

    def to_tuple
      {value: "%.2f" % @value, currency: @currency}
    end
  end
end
