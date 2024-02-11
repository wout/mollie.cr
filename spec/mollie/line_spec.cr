require "../spec_helper.cr"

def test_line
  Mollie::Line.from_json(read_fixture("orderlines/example.json"))
end

describe Mollie::Line do
  describe ".from_json" do
    it "pulls the required attributes" do
      test_line.created_at.should eq(Time.parse_iso8601("2018-08-02T09:29:56+00:00"))
      test_line.id.should eq("odl_dgtxyl")
      test_line.name.should eq("LEGO 42083 Bugatti Chiron")
      test_line.order_id.should eq("ord_kEn1PlbGa")
      test_line.quantity.should eq(2)
      test_line.sku.should eq("5702016116977")
      test_line.status.should eq("created")
      test_line.type.should eq("physical")
      test_line.unit_price.should be_a(Mollie::Amount)
      test_line.unit_price.value.should eq(399.0)
      test_line.vat_amount.should be_a(Mollie::Amount)
      test_line.vat_amount.value.should eq(121.14.to_big_d)
      test_line.vat_rate.should eq("21.00")
      test_line.discount_amount.should be_a(Mollie::Amount)
      test_line.discount_amount.as(Mollie::Amount).value.should eq(100.0)
      test_line.total_amount.should be_a(Mollie::Amount)
      test_line.total_amount.value.should eq(698.0)
      test_line.metadata.should be_a(Mollie::HSBFIS?)
      test_line.is_cancelable.should be_true
      test_line.quantity_shipped.should eq(0)
      test_line.quantity_refunded.should eq(0)
      test_line.quantity_canceled.should eq(0)
      test_line.amount_shipped.should be_a(Mollie::Amount)
      test_line.amount_shipped.as(Mollie::Amount).value.should eq(0.0)
      test_line.amount_refunded.should be_a(Mollie::Amount)
      test_line.amount_refunded.as(Mollie::Amount).value.should eq(0.0)
      test_line.amount_canceled.should be_a(Mollie::Amount)
      test_line.amount_canceled.as(Mollie::Amount).value.should eq(0.0)
      test_line.shippable_quantity.should eq(0)
      test_line.refundable_quantity.should eq(0)
      test_line.cancelable_quantity.should eq(2)
    end
  end

  describe "#links" do
    it "contain links" do
      test_line.link_for("imageUrl").should eq("https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?$main$")
      test_line.link_for("productUrl").should eq("https://shop.lego.com/nl-NL/Bugatti-Chiron-42083")
    end
  end

  describe "#cancelable?" do
    it "tests cancelability" do
      test_line.cancelable?.should be_true
    end
  end

  describe "#discounted?" do
    it "tests descountability" do
      test_line.discounted?.should be_true
    end
  end

  describe "#shippable?" do
    it "tests shippability" do
      test_line.shippable?.should be_false
    end
  end

  describe "#refundable?" do
    it "tests refunablility" do
      test_line.refundable?.should be_false
    end
  end

  describe "#product_url" do
    it "returns the product utl" do
      test_line.product_url.should eq("https://shop.lego.com/nl-NL/Bugatti-Chiron-42083")
    end
  end

  describe "#image_url" do
    it "returns the product's image url" do
      test_line.image_url.should eq("https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?$main$")
    end
  end
end
