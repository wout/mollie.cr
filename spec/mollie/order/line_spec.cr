require "../../spec_helper.cr"

describe Mollie::Order::Line do
  describe "#cancel" do
    pending "deletes the line" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa")
        .to_return(status: 200, body: read_fixture("orders/get.json"))

      order = Mollie::Order.get("ord_kEn1PlbGa")
      order.lines.first.cancel.should be_empty
    end

    pending "only deletes a given quantity" do
    end
  end
end
