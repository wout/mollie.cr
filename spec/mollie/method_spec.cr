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

  describe ".get" do
    context "with pricing" do
      it "includes fees" do
        configure_test_api_key
        json = read_fixture("methods/get-includes-pricing.json")
        WebMock.stub(:get, "https://api.mollie.com/v2/methods/creditcard?include=pricing")
          .to_return(status: 200, body: json)

        creditcard = Mollie::Method.get("creditcard", {include: "pricing"})
        pricing = creditcard.pricing.as(Array(Mollie::Method::Fee))
        pricing.size.should eq(3)
        pricing.first.should be_a(Mollie::Method::Fee)
        pricing.first.description.should eq("Commercial & non-European cards")
        pricing.first.fixed.should be_a(Mollie::Amount)
        pricing.first.variable.should eq(BigDecimal.new("2.8"))
        pricing.first.region.should eq("other")
      end
    end

    context "without pricing" do
      it "does not include fees" do
        configure_test_api_key
        json = read_fixture("methods/get.json")
        WebMock.stub(:get, "https://api.mollie.com/v2/methods/creditcard")
          .to_return(status: 200, body: json)

        creditcard = Mollie::Method.get("creditcard")
        pricing = creditcard.pricing.should be_nil
      end
    end
  end

  describe "#normal_image" do
    it "returns the @1x image" do
      method = Mollie::Method.from_json(method_with_pricing_json)
      method.normal_image.should eq(method.image["size1x"])
    end
  end

  describe "#bigger_image" do
    it "returns the @2x image" do
      method = Mollie::Method.from_json(method_with_pricing_json)
      method.bigger_image.should eq(method.image["size2x"])
    end
  end

  describe "#vector_image" do
    it "returns the vector image" do
      method = Mollie::Method.from_json(method_with_pricing_json)
      method.vector_image.should eq(method.image["svg"])
    end
  end
end
