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
    it "contain links" do
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
      refund.created_at.should eq(Time.parse_rfc3339("2018-09-25T17:40:23+00:00"))
      refund.status.should eq("pending")
      refund.settlement_amount.should be_a(Mollie::Amount)
      refund.payment_id.should eq("tr_WDqYK6vllg")
      refund.order_id.should eq("ord_stTC2WHAuS")
      refund.metadata.should be_a(HSBFIS)
      refund.lines.should be_a(Array(Mollie::Orderline))
      refund.lines.size.should eq(2)
    end
  end

  describe "#payment" do
    it "fetches the linked payment" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT")
        .to_return(status: 200, body: read_fixture("refunds/get.json"))
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg")
        .to_return(status: 200, body: read_fixture("payments/get.json"))

      refund = Mollie::Payment::Refund.get("re_4qqhO89gsT", {payment_id: "tr_WDqYK6vllg"})
      refund.payment.id.should eq("tr_WDqYK6vllg")
    end
  end
end
