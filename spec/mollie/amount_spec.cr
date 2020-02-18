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

  describe "#value=" do
    it "allows to set a value" do
      amount = Mollie::Amount.new(0, "EUR")
      amount.value = Math::PI
      amount.value.should eq(Math::PI)
    end

    it "stores value as a big decimal" do
      amount = Mollie::Amount.new(Math::PI, "EUR")
      amount.value.should be_a(BigDecimal)
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
      tuple = Mollie::Amount.new(60.0, "EUR").to_tuple
      tuple.should eq({value: "60.00", currency: "EUR"})
    end
  end
end
