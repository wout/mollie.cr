require "../../spec_helper.cr"

def test_shipment
  Mollie::Order::Shipment.from_json(read_fixture("shipments/get.json"))
end

describe Mollie::Order::Shipment do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "contain links" do
      test_shipment.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_shipment.id.should eq("shp_3wmsgCJN4U")
      test_shipment.order_id.should eq("ord_kEn1PlbGa")
      test_shipment.created_at.should eq(
        Time.parse_iso8601("2018-08-09T14:33:54+00:00"))
      tracking = test_shipment.tracking.as(Mollie::Order::Shipment::Tracking)
      tracking.carrier.should eq("PostNL")
      tracking.code.should eq("3SKABA000000000")
      tracking.url.should eq(
        "http://postnl.nl/tracktrace/?B=3SKABA000000000&P=1016EE&D=NL&T=C")
      test_shipment.lines.should be_a(Array(Mollie::Line))
    end
  end

  describe "#order" do
    it "fetches the order" do
      WebMock.stub(:get, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa")
        .to_return(body: read_fixture("orders/get.json"))

      test_shipment.order.id.should eq("ord_kEn1PlbGa")
    end
  end
end
