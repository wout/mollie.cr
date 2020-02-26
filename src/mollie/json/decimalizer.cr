struct Mollie
  struct Json
    struct Decimalizer
      def self.from_json(pull : JSON::PullParser)
        BigDecimal.new(pull.read_string.to_s)
      end

      def self.to_json(value : BigDecimal, json : JSON::Builder)
        json.string("%.2f" % value)
      end
    end
  end
end
