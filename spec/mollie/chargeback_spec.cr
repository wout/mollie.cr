require "../spec_helper.cr"

def test_chargeback
  Mollie::Chargeback.from_json(read_fixture("chargebacks/get.json"))
end

def test_chargeback_reversed
  Mollie::Chargeback.from_json(read_fixture("chargebacks/get-reversed.json"))
end

describe Mollie::Chargeback do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "contain links" do
      test_chargeback.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_chargeback.id.should eq("chb_n9z0tp")
      test_chargeback.amount.should be_a(Mollie::Amount)
      test_chargeback.settlement_amount.should be_a(Mollie::Amount)
      test_chargeback.created_at.should eq(Time.parse_iso8601("2018-03-14T17:00:52.0Z"))
      test_chargeback.reversed_at.should be_a(Time?)
      test_chargeback.payment_id.should eq("tr_WDqYK6vllg")
    end
  end

  describe "#reversed?" do
    it "tests nevative if it is not yet reversed" do
      test_chargeback.reversed?.should be_false
    end

    it "tests positive if it is reversed" do
      test_chargeback_reversed.reversed?.should be_true
    end
  end

  describe "#payment" do
    it "returns the related payment" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg")
        .to_return(status: 200, body: read_fixture("payments/get.json"))

      test_chargeback_reversed.payment.id.should eq("tr_WDqYK6vllg")
    end
  end

  describe "#settlement" do
    it "returns the related settlement" do
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/stl_jDk30akdN")
        .to_return(status: 200, body: read_fixture("settlements/get.json"))

      settlement = test_chargeback_reversed.settlement.as(Mollie::Settlement)
      settlement.id.should eq("stl_jDk30akdN")
    end

    it "is nilable" do
      test_chargeback.settlement.should be_nil
    end
  end
end
