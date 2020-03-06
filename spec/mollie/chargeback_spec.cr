require "../spec_helper.cr"

describe Mollie::Chargeback do
  describe "#links" do
    it "contain links" do
      chargeback = Mollie::Chargeback.from_json(read_fixture("chargebacks/get.json"))
      links = chargeback.links.as(HSHS2)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      chargeback = Mollie::Chargeback.from_json(read_fixture("chargebacks/get.json"))
      chargeback.id.should eq("chb_n9z0tp")
      chargeback.amount.should be_a(Mollie::Amount)
      chargeback.settlement_amount.should be_a(Mollie::Amount)
      chargeback.created_at.should eq(Time.parse_rfc3339("2018-03-14T17:00:52.0Z"))
      chargeback.reversed_at.should be_a(Time?)
      chargeback.payment_id.should eq("tr_WDqYK6vllg")
    end
  end

  describe "#reversed?" do
    it "tests nevative if it is not yet reversed" do
      chargeback = Mollie::Chargeback.from_json(read_fixture("chargebacks/get.json"))
      chargeback.reversed?.should be_false
    end

    it "tests positive if it is reversed" do
      chargeback = Mollie::Chargeback.from_json(read_fixture("chargebacks/get-reversed.json"))
      chargeback.reversed?.should be_true
    end
  end

  describe "#payment" do
    it "returns the related payment" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg")
        .to_return(status: 200, body: read_fixture("payments/get.json"))

      chargeback = Mollie::Chargeback.from_json(read_fixture("chargebacks/get-reversed.json"))
      chargeback.payment.id.should eq("tr_WDqYK6vllg")
    end
  end
end
