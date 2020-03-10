require "../../spec_helper.cr"

def get_test_order
  Mollie::Order.get("ord_kEn1PlbGa")
end

describe Mollie::Order::Line do
  before_each do
    configure_test_api_key
  end

  describe "#cancel" do
    it "deletes the line" do
      WebMock.stub(:get, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa")
        .to_return(status: 200, body: read_fixture("orders/get.json"))
      WebMock.stub(:delete, "https://api.mollie.com/v2/orders/ord_pbjz8x/lines/odl_dgtxyl")
        .with(body: %({"lines":[{"id":"odl_dgtxyl","quantity":2}]}))
        .to_return(status: 204, body: "")

      get_test_order.lines.first.cancel.should be_empty
    end

    it "only deletes a given quantity" do
      WebMock.stub(:get, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa")
        .to_return(status: 200, body: read_fixture("orders/get.json"))
      WebMock.stub(:delete, "https://api.mollie.com/v2/orders/ord_pbjz8x/lines/odl_dgtxyl")
        .with(body: %({"lines":[{"id":"odl_dgtxyl","quantity":1}]}))
        .to_return(status: 204, body: "")

      get_test_order.lines.first.cancel({quantity: 1}).should be_empty
    end
  end
end
