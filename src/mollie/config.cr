module Mollie
  def self.configure(&) : Void
    yield(Mollie.config)
  end

  # Finds or creates a config instance in the current fiber.
  def self.config : Mollie::Config
    Fiber.current.mollie_config ||= Config.new
  end

  class Config
    property api_key : String?
    property open_timeout : Time::Span = 60.seconds
    property read_timeout : Time::Span = 60.seconds
    property currency_decimals = {
      "ISK" => 0,
      "JPY" => 0,
    }
  end
end
