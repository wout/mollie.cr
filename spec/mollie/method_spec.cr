require "../spec_helper.cr"
require "../spec_helpers/method_helper.cr"

describe Mollie::Method do
  describe "Type enum" do
    describe "#to_s" do
      it "converts to lower case" do
        Mollie::Method::Type::ApplePay.to_s.should eq("applepay")
      end
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      method = Mollie::Method.from_json(method_with_pricing_json)

      method.id.should eq("creditcard")
      method.description.should eq("Credit card")
      method.minimum_amount.should be_a(Mollie::Amount)
      method.minimum_amount.to_tuple.should eq({value: "0.01", currency: "EUR"})
      method.maximum_amount.should be_a(Mollie::Amount)
      method.maximum_amount.to_tuple.should eq({value: "2000.00", currency: "EUR"})
      method.image["size1x"].should eq("https://www.mollie.com/external/icons/payment-methods/creditcard.png")
      method.image["size2x"].should eq("https://www.mollie.com/external/icons/payment-methods/creditcard%402x.png")
      method.image["svg"].should eq("https://www.mollie.com/external/icons/payment-methods/creditcard.svg")
    end
  end

  describe "#normal_image" do
    it "returns the @1x image size" do
      method = Mollie::Method.from_json(method_with_pricing_json)
      method.normal_image.should eq(method.image["size1x"])
    end
  end

  describe "#bigger_image" do
    it "returns the @1x image size" do
      method = Mollie::Method.from_json(method_with_pricing_json)
      method.bigger_image.should eq(method.image["size2x"])
    end
  end

  describe "#vector_image" do
    it "returns the @1x image size" do
      method = Mollie::Method.from_json(method_with_pricing_json)
      method.vector_image.should eq(method.image["svg"])
    end
  end
end
