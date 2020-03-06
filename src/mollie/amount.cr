struct Mollie
  struct Amount
    include Json::Serializable

    json_field(:value, BigDecimal)
    json_field(:currency, String)

    def initialize(value : Float64 | Int32 | String, currency : String)
      @value = BigDecimal.new(value.to_s)
      @currency = currency
    end

    def to_tuple
      {value: "%.2f" % @value, currency: @currency}
    end

    delegate to_h, to: to_tuple
  end
end
