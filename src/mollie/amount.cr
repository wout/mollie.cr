require "big"

struct Mollie
  struct Amount
    getter :value, :currency

    def initialize(
      value : Float64 | Int32 | String?,
      @currency : String? = nil
    )
      @value = BigDecimal.new((value || 0).to_s)
    end

    def to_tuple
      {value: "%.2f" % @value, currency: @currency}
    end
  end
end
