require "../spec_helper.cr"

describe Mollie::Order do
  describe "Status enum" do
    describe "#to_s" do
      it "converts to lower case" do
        Mollie::Order::Status::Paid.to_s.should eq("paid")
      end
    end

    describe "#==" do
      it "tests against a lower case string" do
        (Mollie::Order::Status::Expired == "expired").should be_true
      end
    end
  end

  describe "#links" do
    it "is linkable" do
      payment = Mollie::Order.from_json(read_fixture("orders/get.json"))
      payment.links.should be_a(Links)
    end
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      order = Mollie::Order.from_json(read_fixture("orders/get.json"))
      order.authorized?.should be_false
      order.canceled?.should be_false
      order.completed?.should be_false
      order.created?.should be_true
      order.expired?.should be_false
      order.paid?.should be_false
      order.pending?.should be_false
      order.shipping?.should be_false
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      order = Mollie::Order.from_json(read_fixture("orders/get.json"))

      order.id.should eq("ord_kEn1PlbGa")
      order.profile_id.should eq("pfl_URR55HPMGx")
      order.method.should eq("ideal")
      order.amount.should be_a(Mollie::Amount)
      order.status.should eq("created")
      order.is_cancelable.should be_true
      order.metadata.should be_a(HSBFIS?)
      order.created_at.should eq(Time.parse_iso8601("2018-08-02T09:29:56+00:00"))
      order.expires_at.should eq(Time.parse_iso8601("2018-08-30T09:29:56+00:00"))
      order.mode.should eq("live")
      order.locale.should eq("nl_NL")
      address = order.billing_address
      address.should be_a(Mollie::Order::Address)
      address.organization_name.should eq("Mollie B.V.")
      address.street_and_number.should eq("Keizersgracht 313")
      address.postal_code.should eq("1016 EE")
      address.city.should eq("Amsterdam")
      address.country.should eq("nl")
      address.given_name.should eq("Luke")
      address.family_name.should eq("Skywalker")
      address.email.should eq("luke@skywalker.com")
      order.shopper_country_must_match_billing_country.should be_false
      order.consumer_date_of_birth.should eq("1993-10-21")
      order.order_number.should eq("18475")
      address = order.shipping_address
      address.should be_a(Mollie::Order::Address)
      address.organization_name.should eq("Mollie B.V.")
      address.street_and_number.should eq("Keizersgracht 313")
      address.postal_code.should eq("1016 EE")
      address.city.should eq("Amsterdam")
      address.country.should eq("nl")
      address.given_name.should eq("Luke")
      address.family_name.should eq("Skywalker")
      address.email.should eq("luke@skywalker.com")
      order.redirect_url.should eq("https://example.org/redirect")
      order.lines.should be_a(Array(Mollie::Orderline))
    end
  end

  describe "#checkout_url" do
    it "returns the checkout url from links" do
      order = Mollie::Order.from_json(read_fixture("orders/get.json"))
      order.checkout_url.should eq("https://www.mollie.com/payscreen/order/checkout/pbjz8x")
    end
  end

  describe "#refunds" do
    it "gets all related refunds" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa/refunds")
        .to_return(status: 200, body: read_fixture("refunds/all.json"))

      order = Mollie::Order.from_json(read_fixture("orders/get.json"))
      order.refunds.should be_a(Mollie::List(Mollie::Order::Refund))
      order.refunds.size.should eq(1)
    end
  end

  describe "#refund!" do
    it "create refund" do
      refund_body = {
        :lines       => [] of Array(Mollie::Orderline),
        :description => "Required quantity not in stock, refunding one photo book.",
      }

      configure_test_api_key
      WebMock.stub(:post, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa/refunds")
        .with(body: refund_body.to_json, headers: empty_string_hash)
        .to_return(status: 200, body: read_fixture("refunds/get.json"))

      order = Mollie::Order.from_json(read_fixture("orders/get.json"))
      refund = order.refund!(refund_body)
      refund.should be_a(Mollie::Order::Refund)
      refund.id.should eq("re_4qqhO89gsT")
      refund.order_id.should eq("ord_stTC2WHAuS")
    end
  end
end
