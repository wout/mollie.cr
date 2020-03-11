require "../../spec_helper.cr"

def test_capture
  Mollie::Payment::Capture.from_json(read_fixture("captures/get.json"))
end

describe Mollie::Payment::Capture do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "contain links" do
      test_capture.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required fields" do
      test_capture.amount.should be_a(Mollie::Amount)
      test_capture.created_at.should eq(Time.parse_iso8601("2018-08-02T09:29:56+00:00"))
      test_capture.id.should eq("cpt_4qqhO89gsT")
      test_capture.mode.should eq("live")
      test_capture.payment_id.should eq("tr_WDqYK6vllg")
      test_capture.settlement_amount.should be_a(Mollie::Amount)
      test_capture.settlement_id.should eq("stl_jDk30akdN")
      test_capture.shipment_id.should eq("shp_3wmsgCJN4U")
    end
  end

  describe "#payment" do
    it "fetches the related payment" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg")
        .to_return(status: 200, body: read_fixture("payments/get.json"))

      test_capture.payment.id.should eq("tr_WDqYK6vllg")
    end
  end

  describe "#shipment" do
    it "fetches the related shipment" do
      WebMock.stub(:get, "https://api.mollie.com/v2/orders/ord_8wmqcHMN4U/shipments/shp_3wmsgCJN4U")
        .to_return(status: 200, body: read_fixture("shipments/get.json"))

      test_capture.shipment.as(Mollie::Order::Shipment).id.should eq("shp_3wmsgCJN4U")
    end

    it "is nilable" do
      capture = Mollie::Payment::Capture
        .from_json(read_fixture("captures/get-without-shipment.json"))
      capture.shipment.should be_nil
    end
  end

  describe "#settlement" do
    it "fetches the related settlement" do
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/stl_jDk30akdN")
        .to_return(status: 200, body: read_fixture("settlements/get.json"))

      test_capture.settlement.as(Mollie::Settlement).id.should eq("stl_jDk30akdN")
    end

    it "is nilable" do
      capture = Mollie::Payment::Capture
        .from_json(read_fixture("captures/get-without-settlement.json"))
      capture.settlement.should be_nil
    end
  end
end
