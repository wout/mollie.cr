require "../spec_helper.cr"

describe Mollie::Amount do
  describe "#initialize" do
    it "accepts a value and currency" do
      amount = Mollie::Amount.new(value: 12.34, currency: "EUR")
      amount.value.should eq(12.34)
      amount.currency.should eq("EUR")
    end

    it "accepts a value as integer" do
      amount = Mollie::Amount.new(value: 4040, currency: "EUR")
      amount.value.should eq(4040.0)
    end

    it "accepts a value as string" do
      amount = Mollie::Amount.new(value: "3.1415")
      amount.value.should eq(3.1415)
    end

    it "accepts nil" do
      amount = Mollie::Amount.new(nil)
      amount.value.should eq(0.0)
      amount.currency.should be_nil
    end
  end

  describe "#value" do
    it "returns the given value" do
      amount = Mollie::Amount.new(32.32)
      amount.value.should eq(32.32)
    end
  end

  describe "#currency" do
    it "returns the given value" do
      amount = Mollie::Amount.new(0, "EUR")
      amount.currency.should eq("EUR")
    end
  end

  describe "#as_tuple" do
    it "returns the value/currency pair as a tuple" do
      tuple = Mollie::Amount.new(value: 60.0, currency: "EUR").to_tuple
      tuple.should eq({value: "60.00", currency: "EUR"})
    end
  end
end
