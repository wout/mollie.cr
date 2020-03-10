require "../spec_helper.cr"

def test_order
  Mollie::Order.from_json(read_fixture("orders/get.json"))
end

describe Mollie::Order do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "is linkable" do
      test_order.links.should be_a(Links)
    end
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      test_order.authorized?.should be_false
      test_order.canceled?.should be_false
      test_order.completed?.should be_false
      test_order.created?.should be_true
      test_order.expired?.should be_false
      test_order.paid?.should be_false
      test_order.pending?.should be_false
      test_order.shipping?.should be_false
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_order.id.should eq("ord_kEn1PlbGa")
      test_order.profile_id.should eq("pfl_URR55HPMGx")
      test_order.method.should eq("ideal")
      test_order.amount.should be_a(Mollie::Amount)
      test_order.status.should eq("created")
      test_order.is_cancelable.should be_true
      test_order.metadata.should be_a(HSBFIS?)
      test_order.created_at.should eq(Time.parse_iso8601("2018-08-02T09:29:56+00:00"))
      test_order.expires_at.should eq(Time.parse_iso8601("2018-08-30T09:29:56+00:00"))
      test_order.mode.should eq("live")
      test_order.locale.should eq("nl_NL")
      address = test_order.billing_address
      address.should be_a(Mollie::Order::Address)
      address.organization_name.should eq("Mollie B.V.")
      address.street_and_number.should eq("Keizersgracht 313")
      address.postal_code.should eq("1016 EE")
      address.city.should eq("Amsterdam")
      address.country.should eq("nl")
      address.given_name.should eq("Luke")
      address.family_name.should eq("Skywalker")
      address.email.should eq("luke@skywalker.com")
      test_order.shopper_country_must_match_billing_country.should be_false
      test_order.consumer_date_of_birth.should eq("1993-10-21")
      test_order.order_number.should eq("18475")
      address = test_order.shipping_address
      address.should be_a(Mollie::Order::Address)
      address.organization_name.should eq("Mollie B.V.")
      address.street_and_number.should eq("Keizersgracht 313")
      address.postal_code.should eq("1016 EE")
      address.city.should eq("Amsterdam")
      address.country.should eq("nl")
      address.given_name.should eq("Luke")
      address.family_name.should eq("Skywalker")
      address.email.should eq("luke@skywalker.com")
      test_order.redirect_url.should eq("https://example.org/redirect")
      test_order.lines.should be_a(Array(Mollie::Order::Line))
    end
  end

  describe "#checkout_url" do
    it "returns the checkout url from links" do
      test_order.checkout_url.should eq("https://www.mollie.com/payscreen/order/checkout/pbjz8x")
    end
  end

  describe "#refunds" do
    it "gets all related refunds" do
      WebMock.stub(:get, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa/refunds")
        .to_return(status: 200, body: read_fixture("refunds/all.json"))

      test_order.refunds.should be_a(Mollie::List(Mollie::Order::Refund))
      test_order.refunds.size.should eq(1)
    end
  end

  describe "#refund!" do
    it "create refund" do
      refund_body = {
        :lines       => [] of Array(Mollie::Order::Line),
        :description => "Required quantity not in stock, refunding one photo book.",
      }

      WebMock.stub(:post, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa/refunds")
        .with(body: refund_body.to_json, headers: empty_string_hash)
        .to_return(status: 200, body: read_fixture("refunds/get.json"))

      refund = test_order.refund!(refund_body)
      refund.should be_a(Mollie::Order::Refund)
      refund.id.should eq("re_4qqhO89gsT")
      refund.order_id.should eq("ord_stTC2WHAuS")
    end
  end
end
