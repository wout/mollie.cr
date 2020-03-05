require "../spec_helper.cr"

describe Mollie::Orderline do
  describe ".from_json" do
    it "pulls the required attributes" do
      orderline = Mollie::Orderline.from_json(read_fixture("orderlines/example.json"))

      orderline.created_at.should eq(Time.parse_rfc3339("2018-08-02T09:29:56+00:00"))
      orderline.id.should eq("odl_dgtxyl")
      orderline.name.should eq("LEGO 42083 Bugatti Chiron")
      orderline.order_id.should eq("ord_kEn1PlbGa")
      orderline.quantity.should eq(2)
      orderline.sku.should eq("5702016116977")
      orderline.status.should eq("created")
      orderline.type.should eq("physical")
      orderline.unit_price.should be_a(Mollie::Amount)
      orderline.unit_price.value.should eq(399.0)
      orderline.vat_amount.should be_a(Mollie::Amount)
      orderline.vat_amount.value.should eq(121.14)
      orderline.vat_rate.should eq("21.00")
      orderline.discount_amount.should be_a(Mollie::Amount)
      orderline.discount_amount.value.should eq(100.0)
      orderline.total_amount.should be_a(Mollie::Amount)
      orderline.total_amount.value.should eq(698.0)
      orderline.metadata.should be_a(HSBFIS)
      orderline.is_cancelable.should be_true
      orderline.quantity_shipped.should eq(0)
      orderline.quantity_refunded.should eq(0)
      orderline.quantity_canceled.should eq(0)
      orderline.amount_shipped.should be_a(Mollie::Amount)
      orderline.amount_shipped.as(Mollie::Amount).value.should eq(0.0)
      orderline.amount_refunded.should be_a(Mollie::Amount)
      orderline.amount_refunded.as(Mollie::Amount).value.should eq(0.0)
      orderline.shippable_quantity.should eq(0)
      orderline.refundable_quantity.should eq(0)
      orderline.cancelable_quantity.should eq(2)
    end
  end

  describe "#links" do
    it "contain links" do
      orderline = Mollie::Orderline.from_json(read_fixture("orderlines/example.json"))
      links = orderline.links.as(HSHS2)
      links["imageUrl"]["href"].should eq("https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?$main$")
      links["productUrl"]["href"].should eq("https://shop.lego.com/nl-NL/Bugatti-Chiron-42083")
    end
  end
end
