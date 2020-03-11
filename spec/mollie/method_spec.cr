require "../spec_helper.cr"

def test_method
  Mollie::Method.from_json(read_fixture("methods/get.json"))
end

describe Mollie::Method do
  before_each do
    configure_test_api_key
  end

  describe "Type enum" do
    describe "#to_s" do
      it "converts to lower case" do
        Mollie::Method::Type::ApplePay.to_s.should eq("applepay")
      end
    end

    describe "#==" do
      it "tests against a lower case string" do
        (Mollie::Method::Type::IngHomePay == "inghomepay").should be_true
      end
    end
  end

  describe "#links" do
    it "is linkable" do
      test_method.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_method.id.should eq("ideal")
      test_method.description.should eq("iDEAL")
      test_method.minimum_amount.should be_a(Mollie::Amount)
      test_method.minimum_amount.to_tuple.should eq({value: "0.01", currency: "EUR"})
      test_method.maximum_amount.should be_a(Mollie::Amount)
      test_method.maximum_amount.to_tuple.should eq({value: "50000.00", currency: "EUR"})
      test_method.image["size1x"].should eq("https://www.mollie.com/external/icons/payment-methods/ideal.png")
      test_method.image["size2x"].should eq("https://www.mollie.com/external/icons/payment-methods/ideal%402x.png")
      test_method.image["svg"].should eq("https://www.mollie.com/external/icons/payment-methods/ideal.svg")
    end
  end

  describe ".get" do
    context "with pricing" do
      it "includes fees" do
        WebMock.stub(:get, "https://api.mollie.com/v2/methods/creditcard?include=pricing")
          .to_return(status: 200, body: read_fixture("methods/get-includes-pricing.json"))

        creditcard = Mollie::Method.get("creditcard", {include: "pricing"})
        pricing = creditcard.pricing.as(Array(Mollie::Method::Fee))
        pricing.size.should eq(3)
        pricing.first.should be_a(Mollie::Method::Fee)
        pricing.first.description.should eq("Commercial & non-European cards")
        pricing.first.fixed.should be_a(Mollie::Amount)
        pricing.first.variable.should eq(BigDecimal.new("2.8"))
        pricing.first.fee_region.should eq("other")
      end
    end

    context "without pricing" do
      it "does not include fees" do
        WebMock.stub(:get, "https://api.mollie.com/v2/methods/creditcard")
          .to_return(status: 200, body: read_fixture("methods/get.json"))

        creditcard = Mollie::Method.get("creditcard")
        creditcard.pricing.should be_nil
      end
    end
  end

  describe "#normal_image" do
    it "returns the @1x image" do
      test_method.normal_image.should eq(test_method.image["size1x"])
    end
  end

  describe "#bigger_image" do
    it "returns the @2x image" do
      test_method.bigger_image.should eq(test_method.image["size2x"])
    end
  end

  describe "#vector_image" do
    it "returns the vector image" do
      test_method.vector_image.should eq(test_method.image["svg"])
    end
  end
end
