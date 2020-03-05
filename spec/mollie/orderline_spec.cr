require "../spec_helper.cr"

describe Mollie::Orderline do
  describe ".from_json" do
    it "pulls the required attributes" do
      orderline = Mollie::Orderline.from_json(read_fixture("orderlines/example.json"))

      orderline.created_at.should eq(Time.parse_rfc3339("2018-08-02T09:29:56+00:00"))
      orderline.id.should eq("odl_dgtxyl")
      orderline.image_url.should eq("https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?$main$")
      orderline.name.should eq("LEGO 42083 Bugatti Chiron")
      orderline.order_id.should eq("ord_kEn1PlbGa")
      orderline.product_url.should eq("https://shop.lego.com/nl-NL/Bugatti-Chiron-42083")
      orderline.quantity.should eq(2)
      orderline.sku.should eq("5702016116977")
      orderline.status.should eq("refunded")
      orderline.type.should eq("physical")
      orderline.unit_price.should be_a(Mollie::Amount)
      orderline.unit_price.value.should eq(399.0)
      orderline.vat_amount.should be_a(Mollie::Amount)
      orderline.vat_amount.value.should eq(121.14)
      orderline.vat_rate.should eq("21.00")
      orderline.discount_amount.should be_a(Mollie::Amount)
      orderline.discount_amount.value.should eq(100.00)
      orderline.total_amount.should be_a(Mollie::Amount)
      orderline.total_amount.value.should eq(698.00)
    end
  end
end
