require "../spec_helper.cr"

describe Mollie::Amount do
  describe "#initialize" do
    it "accepts a value and currency" do
      amount = Mollie::Amount.new(12.34, "EUR")
      amount.value.should eq(12.34)
      amount.currency.should eq("EUR")
    end

    it "accepts a value as integer" do
      amount = Mollie::Amount.new(4040, "EUR")
      amount.value.should eq(4040.0)
    end

    it "accepts a value as string" do
      amount = Mollie::Amount.new("3.1415", "EUR")
      amount.value.should eq(3.1415)
    end
  end

  describe "#value" do
    it "returns the given value" do
      amount = Mollie::Amount.new(32.32, "EUR")
      amount.value.should eq(32.32)
    end
  end

  describe "#currency" do
    it "returns the given value" do
      amount = Mollie::Amount.new(0, "EUR")
      amount.currency.should eq("EUR")
    end
  end

  describe "#to_tuple" do
    it "returns the value/currency pair as a named tuple" do
      tuple = Mollie::Amount.new(60.0, "EUR").to_tuple
      tuple.should eq({value: "60.00", currency: "EUR"})
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
