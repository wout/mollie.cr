require "../spec_helper.cr"

def test_refund
  Mollie::Refund.from_json(read_fixture("refunds/get.json"))
end

describe Mollie::Refund do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "contain links" do
      test_refund.link_for("self").should eq("https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT")
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_refund.id.should eq("re_4qqhO89gsT")
      test_refund.description.should eq("Required quantity not in stock, refunding one photo book.")
      test_refund.amount.should be_a(Mollie::Amount)
      test_refund.created_at.should eq(Time.parse_iso8601("2018-09-25T17:40:23+00:00"))
      test_refund.status.should eq("pending")
      test_refund.settlement_amount.should be_a(Mollie::Amount)
      test_refund.settlement_id.should be_a(Mollie::Settlement?)
      test_refund.payment_id.should eq("tr_WDqYK6vllg")
      test_refund.order_id.should eq("ord_stTC2WHAuS")
      test_refund.metadata.should be_a(Mollie::HSBFIS)
      lines = test_refund.lines.as(Array(Mollie::Line))
      lines.size.should eq(2)
    end
  end

  describe "#payment" do
    it "fetches the related payment" do
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
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsE")
        .to_return(status: 200, body: read_fixture("refunds/get-with-settlement.json"))
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/stl_jDk30akdN")
        .to_return(status: 200, body: read_fixture("settlements/get.json"))

      refund = Mollie::Payment::Refund.get("re_4qqhO89gsE", {payment_id: "tr_WDqYK6vllg"})
      refund.settlement.as(Mollie::Settlement).id.should eq("stl_jDk30akdN")
    end

    it "is nilable" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds/re_4qqhO89gsT")
        .to_return(status: 200, body: read_fixture("refunds/get.json"))

      refund = Mollie::Payment::Refund.get("re_4qqhO89gsT", {payment_id: "tr_WDqYK6vllg"})
      refund.settlement.should be_nil
    end
  end
end
