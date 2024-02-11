require "../spec_helper.cr"

describe Mollie::Amount do
  describe "#initialize" do
    it "accepts a value and currency" do
      amount = Mollie::Amount.new(12.34, "EUR")
      amount.value.should eq(12.34.to_big_d)
      amount.currency.should eq("EUR")
    end

    it "accepts a value as integer" do
      Mollie::Amount.new(-3232.to_i32, "EUR").value.should eq(-3232.0)
      Mollie::Amount.new(3232.to_u32, "EUR").value.should eq(3232.0)
      Mollie::Amount.new(-6464.to_i64, "EUR").value.should eq(-6464.0)
      Mollie::Amount.new(6464.to_u64, "EUR").value.should eq(6464.0)
    end

    it "accepts a value as float" do
      Mollie::Amount.new(3232.to_f32, "EUR").value.should eq(3232.0)
      Mollie::Amount.new(-6464.to_f64, "EUR").value.should eq(-6464.0)
    end

    it "accepts a value as string" do
      Mollie::Amount.new("3.1415", "EUR").value.should eq(3.1415.to_big_d)
    end

    it "accepts a value as big decimal" do
      amount = Mollie::Amount.new(BigDecimal.new("3.1415"), "EUR")
      amount.value.should eq(3.1415.to_big_d)
      amount.currency.should eq("EUR")
    end
  end

  describe "#value" do
    it "returns the given value" do
      Mollie::Amount.new(32.32, "EUR").value.should eq(32.32.to_big_d)
    end
  end

  describe "#currency" do
    it "returns the given value" do
      Mollie::Amount.new(0, "EUR").currency.should eq("EUR")
    end
  end

  describe "#to_tuple" do
    it "returns the value/currency pair as a named tuple" do
      tuple = Mollie::Amount.new(60.0, "EUR").to_tuple
      tuple.should eq({value: "60.00", currency: "EUR"})
    end

    it "rounds the amount according to the given currency" do
      Mollie.config.currency_decimals["SEK"] = 4
      tuple = Mollie::Amount.new(60.31555, "EUR").to_tuple
      tuple.should eq({value: "60.32", currency: "EUR"})
      tuple = Mollie::Amount.new(60.31555, "JPY").to_tuple
      tuple.should eq({value: "60", currency: "JPY"})
      tuple = Mollie::Amount.new(60.31555, "SEK").to_tuple
      tuple.should eq({value: "60.3156", currency: "SEK"})
      tuple = Mollie::Amount.new(65.985, "GBP").to_tuple
      tuple.should eq({value: "65.99", currency: "GBP"})
    end
  end

  describe "#to_h" do
    it "returns the value/currency pair as a hash" do
      hash = Mollie::Amount.new(60.0, "EUR").to_h
      hash.should eq({:value => "60.00", :currency => "EUR"})
    end
  end

  describe "#to_json" do
    it "returns the value/currency pair as json" do
      json = Mollie::Amount.new(1.1189, "EUR").to_json
      json.should eq(%({"value":"1.12","currency":"EUR"}))
    end
  end
end
