module Mollie
  struct Amount
    include Json::Serializable

    json_field(:value, BigDecimal)
    json_field(:currency, String)

    def initialize(value : AmountValue, currency : String)
      @value = BigDecimal.new(value.to_s)
      @currency = currency
    end

    def initialize(@value : BigDecimal, @currency)
    end

    def to_tuple
      {
        value:    Util.amount_with_decimals(@value, @currency),
        currency: @currency,
      }
    end

    delegate to_h, to: to_tuple
  end
end
