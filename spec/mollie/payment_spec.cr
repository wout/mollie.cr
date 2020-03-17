require "../spec_helper.cr"

def test_payment
  Mollie::Payment.from_json(read_fixture("payments/get.json"))
end

def test_payment_with_relations
  Mollie::Payment.from_json(read_fixture("payments/get-with-relations.json"))
end

describe Mollie::Payment do
  before_each do
    configure_test_api_key
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      test_payment.open?.should be_true
      test_payment.canceled?.should be_false
      test_payment.pending?.should be_false
      test_payment.expired?.should be_false
      test_payment.failed?.should be_false
      test_payment.paid?.should be_false
      test_payment.authorized?.should be_false
    end
  end

  describe "#links" do
    it "is linkable" do
      test_payment.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      payment = Mollie::Payment.from_json(read_fixture("payments/get-complete.json"))
      payment.id.should eq("tr_7UhSN1zuXS")
      payment.mode.should eq("test")
      payment.description.should eq("My first payment")
      payment.created_at.should eq(Time.parse_iso8601("2018-03-20T09:13:37+00:00"))
      payment.canceled_at.should be_a(Time?)
      payment.expired_at.should be_a(Time?)
      payment.expires_at.should be_a(Time?)
      payment.failed_at.should be_a(Time?)
      payment.is_cancelable.should be_a(Bool?)
      payment.status.should eq("paid")
      payment.authorized_at.should eq(Time.parse_iso8601("2018-03-19T09:14:37+00:00"))
      payment.paid_at.should eq(Time.parse_iso8601("2018-03-20T09:14:37+00:00"))
      payment.amount.should be_a(Mollie::Amount)
      payment.amount_captured.should be_a(Mollie::Amount?)
      payment.amount_refunded.should be_a(Mollie::Amount?)
      payment.amount_remaining.should be_a(Mollie::Amount?)
      payment.description.should eq("My first payment")
      payment.method.should eq("ideal")
      metadata = payment.metadata.as(Mollie::HSBFIS)
      metadata["order_id"].should eq("12345")
      details = payment.details.as(Mollie::HSBFIS)
      details["consumer_name"].should eq("Hr E G H K\u00fcppers en/of MW M.J. K\u00fcppers-Veeneman")
      details["consumer_account"].should eq("NL53INGB0618365937")
      details["consumer_bic"].should eq("INGBNL2A")
      payment.locale.should eq("nl_NL")
      payment.country_code.should eq("NL")
      payment.profile_id.should eq("pfl_QkEhN94Ba")
      payment.webhook_url.should eq("https://webshop.example.org/payments/webhook")
      payment.application_fee.should be_a(Mollie::Payment::ApplicationFee?)
      payment.mandate_id.should be_a(String?)
      payment.order_id.should be_a(String?)
      payment.sequence_type.should be_a(String?)
      payment.settlement_amount.should be_a(Mollie::Amount?)
      payment.settlement_id.should be_a(String?)
      payment.subscription_id.should be_a(String?)
    end

    it "allows nilable values" do
      payment = Mollie::Payment.from_json(read_fixture("payments/get-open.json"))
      payment.authorized_at.should be_nil
    end
  end

  describe "#refunded?" do
    it "tests positive with a refunded amount" do
      payment = Mollie::Payment.from_json(read_fixture("payments/get-refunded.json"))
      payment.amount_refunded.should be_a(Mollie::Amount)
      payment.refunded?.should be_true
    end
    it "tests negative with a refunded amount of zero" do
      payment = Mollie::Payment.from_json(read_fixture("payments/get-zero-refunded.json"))
      payment.refunded?.should be_false
    end
    it "tests negative without a refunede amount" do
      test_payment.refunded?.should be_false
    end
  end

  describe "#checkout_url" do
    it "fetches the checkout url from links" do
      test_payment.checkout_url.should eq(test_payment.link_for("checkout"))
    end
  end

  describe "#application_fee" do
    it "parses the application fee as an object" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllf")
        .to_return(status: 200, body: read_fixture("payments/get-complete.json"))

      payment = Mollie::Payment.get("tr_WDqYK6vllf")
      fee = payment.application_fee.as(Mollie::Payment::ApplicationFee)
      fee.amount.value.should eq(42.1)
      fee.amount.currency.should eq("EUR")
      fee.description.should eq("Example application fee")
    end
  end

  describe "#restrict_payment_methods_to_country" do
    it "restricts a payment to a country" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vlle")
        .to_return(status: 200, body: read_fixture("payments/get.json"))

      payment = Mollie::Payment.get("tr_WDqYK6vlle")
      payment.restrict_payment_methods_to_country.should eq("NL")
    end
  end

  describe ".create" do
    it "creates a payment" do
      body = %({"amount":{"value":"1.95","currency":"EUR"}})
      WebMock.stub(:post, "https://api.mollie.com/v2/payments")
        .with(body: body)
        .to_return(status: 201, body: read_fixture("payments/post.json"))

      payment = Mollie::Payment.create({
        amount: {value: "1.95", currency: "EUR"},
      })
      payment.should be_a(Mollie::Payment)
      payment.id.should eq("tr_WDqYK6vllg")
      payment.amount.value.should eq(1.95)
      payment.amount.currency.should eq("EUR")
    end

    it "creates a payment for a customer" do
      body = %({"customerId":"cst_8wmqcHMN4U","amount":{"value":"1.95","currency":"EUR"}})
      WebMock.stub(:post, "https://api.mollie.com/v2/payments")
        .with(body: body)
        .to_return(status: 201, body: read_fixture("payments/post.json"))

      payment = Mollie::Payment.create({
        customer_id: "cst_8wmqcHMN4U",
        amount:      {value: "1.95", currency: "EUR"},
      })
      payment.customer_id.should eq("cst_8wmqcHMN4U")
    end

    it "creates a payment with an instance of amount" do
      body = %({"customerId":"cst_8wmqcHMN4V","amount":{"value":"61.98","currency":"GBP"}})
      WebMock.stub(:post, "https://api.mollie.com/v2/payments")
        .with(body: body)
        .to_return(status: 201, body: read_fixture("payments/post.json"))

      Mollie::Payment.create({
        customer_id: "cst_8wmqcHMN4V",
        amount:      Mollie::Amount.new("61.975", "GBP"),
      })
    end
  end

  describe "#refund!" do
    it "refunds a payment" do
      body = %({"amount":{"value":"10.00","currency":"EUR"}})
      WebMock.stub(:post, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds")
        .with(body: body)
        .to_return(body: read_fixture("refunds/get.json"))

      refund = test_payment.refund!
      refund.id.should eq("re_4qqhO89gsT")
    end

    it "refunds a payment with custom amount and description" do
      body = %({"amount":{"value":"9.95","currency":"EUR"},"description":"Test refund"})
      WebMock.stub(:post, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds")
        .with(body: body)
        .to_return(body: read_fixture("refunds/get.json"))

      refund = test_payment.refund!({
        amount:      {value: "9.95", currency: "EUR"},
        description: "Test refund",
      })
      refund.id.should eq("re_4qqhO89gsT")
    end
  end

  describe "#refunds" do
    it "fetches the related refunds" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/refunds")
        .to_return(body: read_fixture("refunds/list.json"))

      test_payment.refunds.first.id.should eq("re_4qqhO89gsT")
    end
  end

  describe "#chargebacks" do
    it "fetches the related chargebacks" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/chargebacks")
        .to_return(body: read_fixture("chargebacks/list.json"))

      test_payment.chargebacks.first.id.should eq("chb_n9z0tp")
    end
  end

  describe "#captures" do
    it "fetches the related captures" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg/captures")
        .to_return(status: 200, body: read_fixture("captures/list.json"))

      test_payment.captures.first.id.should eq("cpt_4qqhO89gsT")
    end
  end

  describe "#customer" do
    it "fetches the related customer" do
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa")
        .to_return(status: 200, body: read_fixture("customers/get.json"))

      customer = test_payment_with_relations.customer.as(Mollie::Customer)
      customer.id.should eq("cst_kEn1PlbGa")
    end

    it "is nilable" do
      test_payment.customer.should be_nil
    end
  end

  describe "#mandate" do
    it "fetches the related mandate" do
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/mandates/mdt_h3gAaD5zP")
        .to_return(status: 200, body: read_fixture("mandates/get.json"))

      mandate = test_payment_with_relations.mandate.as(Mollie::Customer::Mandate)
      mandate.id.should eq("mdt_h3gAaD5zP")
    end

    it "is nilable" do
      test_payment.mandate.should be_nil
    end
  end

  describe "#settlement" do
    it "fetches the related settlement" do
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/stl_jDk30akdN")
        .to_return(status: 200, body: read_fixture("settlements/get.json"))

      settlement = test_payment_with_relations.settlement.as(Mollie::Settlement)
      settlement.id.should eq("stl_jDk30akdN")
    end

    it "is nilable" do
      test_payment.settlement.should be_nil
    end
  end

  describe "#subscription" do
    it "fetches the related subscription" do
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/subscriptions/sub_rVKGtNd6s3")
        .to_return(status: 200, body: read_fixture("subscriptions/get.json"))

      subscription = test_payment_with_relations.subscription.as(Mollie::Customer::Subscription)
      subscription.id.should eq("sub_rVKGtNd6s3")
    end

    it "is nilable" do
      test_payment.subscription.should be_nil
    end
  end

  describe "#order" do
    it "fetches the related order" do
      WebMock.stub(:get, "https://api.mollie.com/v2/orders/ord_kEn1PlbGa")
        .to_return(status: 200, body: read_fixture("orders/get.json"))

      order = test_payment_with_relations.order.as(Mollie::Order)
      order.id.should eq("ord_kEn1PlbGa")
    end

    it "is nilable" do
      test_payment.order.should be_nil
    end
  end
end
