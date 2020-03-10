require "../../spec_helper.cr"

describe Mollie::Order::Shipment do
  describe "#links" do
    it "contain links" do
      shipment = Mollie::Order::Shipment
        .from_json(read_fixture("shipments/get.json"))
      shipment.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      shipment = Mollie::Order::Shipment
        .from_json(read_fixture("shipments/get.json"))
      shipment.id.should eq("shp_3wmsgCJN4U")
      shipment.order_id.should eq("ord_kEn1PlbGa")
      shipment.created_at.should eq(
        Time.parse_iso8601("2018-08-09T14:33:54+00:00"))
      tracking = shipment.tracking.as(Mollie::Order::Shipment::Tracking)
      tracking.carrier.should eq("PostNL")
      tracking.code.should eq("3SKABA000000000")
      tracking.url.should eq(
        "http://postnl.nl/tracktrace/?B=3SKABA000000000&P=1016EE&D=NL&T=C")
      shipment.lines.should be_a(Array(Mollie::Line))
    end
  end

  describe "#order" do
    it "fetches the order" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa")
        .to_return(body: read_fixture("orders/get.json"))

      shipment = Mollie::Order::Shipment
        .from_json(read_fixture("shipments/get.json"))
      shipment.order.id.should eq("ord_kEn1PlbGa")
    end
  end
end
