module Mollie
  struct Json
    struct TimeFormatter
      def self.from_json(pull : JSON::PullParser)
        Time.new(pull)
      end

      def self.to_json(value : Time, json : JSON::Builder)
        json.string(value.to_s("%FT%T+00:00"))
      end
    end
  end
end
