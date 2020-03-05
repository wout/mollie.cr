require "../spec_helper.cr"

describe Mollie::Refund do
  describe "Status enum" do
    describe "#to_s" do
      it "converts to lower case" do
        Mollie::Refund::Status::Queued.to_s.should eq("queued")
      end
    end

    describe "#==" do
      it "tests against a lower case string" do
        (Mollie::Refund::Status::Refunded == "refunded").should be_true
      end
    end
  end

  describe "#links" do
    it "is linkable" do
      refund = Mollie::Refund.from_json(read_fixture("refunds/get.json"))
      links = refund.links.as(HSHS2)
      links["self"]["href"].should eq("https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT")
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      refund = Mollie::Refund.from_json(read_fixture("refunds/get.json"))
      refund.id.should eq("re_4qqhO89gsT")
      refund.description.should eq("Required quantity not in stock, refunding one photo book.")
      refund.amount.should be_a(Mollie::Amount)
      refund.status.should eq("pending")
      refund.settlement_id.should be_a(String?)
      refund.settlement_amount.should be_a(Mollie::Amount)
    end
  end
end
