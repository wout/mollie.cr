struct Mollie
  def self.configure : Void
    yield(Mollie.config)
  end

  # Finds or creates a config instance in the current fiber.
  def self.config : Mollie::Config
    Fiber.current.mollie_config ||= Config.new
  end

  class Config
    property api_key : String?
    property open_timeout : Int32 | Float64 = 60
    property read_timeout : Int32 | Float64 = 60
    property currency_decimals = {
      "ISK" => 0,
      "JPY" => 0,
    }
  end
end
