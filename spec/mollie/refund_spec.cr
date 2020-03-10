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
      refund.link_for("self").should eq("https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT")
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      refund = Mollie::Refund.from_json(read_fixture("refunds/get.json"))
      refund.id.should eq("re_4qqhO89gsT")
      refund.description.should eq("Required quantity not in stock, refunding one photo book.")
      refund.amount.should be_a(Mollie::Amount)
      refund.created_at.should eq(Time.parse_iso8601("2018-09-25T17:40:23+00:00"))
      refund.status.should eq("pending")
      refund.settlement_amount.should be_a(Mollie::Amount)
      refund.settlement_id.should be_a(Mollie::Settlement?)
      refund.payment_id.should eq("tr_WDqYK6vllg")
      refund.order_id.should eq("ord_stTC2WHAuS")
      refund.metadata.should be_a(HSBFIS)
      refund.lines.should be_a(Array(Mollie::Line))
      refund.lines.size.should eq(2)
    end
  end

  describe "#payment" do
    it "fetches the related payment" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT")
        .to_return(status: 200, body: read_fixture("refunds/get.json"))
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg")
        .to_return(status: 200, body: read_fixture("payments/get.json"))

      refund = Mollie::Payment::Refund.get("re_4qqhO89gsT", {payment_id: "tr_WDqYK6vllg"})
      refund.payment.id.should eq("tr_WDqYK6vllg")
    end
  end

  describe "#settlement" do
    it "fetches the related settlement" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsE")
        .to_return(status: 200, body: read_fixture("refunds/get-with-settlement.json"))
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/stl_jDk30akdN")
        .to_return(status: 200, body: read_fixture("settlements/get.json"))

      refund = Mollie::Payment::Refund.get("re_4qqhO89gsE", {payment_id: "tr_WDqYK6vllg"})
      refund.settlement.as(Mollie::Settlement).id.should eq("stl_jDk30akdN")
    end

    it "is nilable" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT")
        .to_return(status: 200, body: read_fixture("refunds/get.json"))

      refund = Mollie::Payment::Refund.get("re_4qqhO89gsT", {payment_id: "tr_WDqYK6vllg"})
      refund.settlement.should be_nil
    end
  end
end
