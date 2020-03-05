require "../spec_helper.cr"
require "../spec_helpers/payment_helper.cr"

describe Mollie::Payment do
  describe "Status enum" do
    describe "#to_s" do
      it "converts to lower case" do
        Mollie::Payment::Status::Paid.to_s.should eq("paid")
      end
    end

    describe "#==" do
      it "tests against a lower case string" do
        (Mollie::Payment::Status::Paid == "paid").should be_true
      end
    end
  end

  describe "#links" do
    it "is linkable" do
      payment = Mollie::Payment.from_json(get_payment_json)
      payment.links.should be_a(HSHS2)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      payment = Mollie::Payment.from_json(get_payment_json)

      payment.id.should eq("tr_7UhSN1zuXS")
      payment.mode.should eq("test")
      payment.description.should eq("My first payment")
      payment.created_at.should eq(Time.parse_rfc3339("2018-03-20T09:13:37+00:00"))
      payment.status.should eq("paid")
      payment.authorized_at.should eq(Time.parse_rfc3339("2018-03-19T09:14:37+00:00"))
      payment.paid_at.should eq(Time.parse_rfc3339("2018-03-20T09:14:37+00:00"))
      payment.amount.should be_a(Mollie::Amount)
      payment.amount_captured.should be_a(Mollie::Amount?)
      payment.amount_refunded.should be_a(Mollie::Amount?)
      payment.amount_remaining.should be_a(Mollie::Amount?)
      payment.description.should eq("My first payment")
      payment.method.should eq("ideal")
      payment.metadata.should be_a(HSBFIS)
      payment.metadata["order_id"].should eq("12345")
      details = payment.details.as(HSBFIS)
      details["consumer_name"].should eq("Hr E G H K\u00fcppers en\/of MW M.J. K\u00fcppers-Veeneman")
      details["consumer_account"].should eq("NL53INGB0618365937")
      details["consumer_bic"].should eq("INGBNL2A")
      payment.locale.should eq("nl_NL")
      payment.country_code.should eq("NL")
      payment.profile_id.should eq("pfl_QkEhN94Ba")
      payment.webhook_url.should eq("https://webshop.example.org/payments/webhook")
      payment.application_fee.should be_a(Mollie::Payment::ApplicationFee?)
    end
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      payment = Mollie::Payment.from_json(get_payment_json)
      payment.open?.should be_false
      payment.canceled?.should be_false
      payment.pending?.should be_false
      payment.expired?.should be_false
      payment.failed?.should be_false
      payment.paid?.should be_true
      payment.authorized?.should be_false
    end
  end

  describe "#refunded?" do
    it "tests positive with a refunded amount" do
      payment = Mollie::Payment.from_json(get_refunded_payment_json)
      payment.amount_refunded.should be_a(Mollie::Amount)
      payment.refunded?.should be_true
    end
    it "tests negative with a refunded amount of zero" do
      payment = Mollie::Payment.from_json(get_zero_refunded_payment_json)
      payment.refunded?.should be_false
    end
    it "tests negative without a refunede amount" do
      payment = Mollie::Payment.from_json(get_payment_json)
      payment.refunded?.should be_false
    end
  end

  describe "#checkout_url" do
    it "fetches the checkout url from links" do
      payment = Mollie::Payment.from_json(get_payment_json)
      payment.checkout_url.should be(payment.links.as(HSHS2)["checkout"]["href"])
    end
  end

  describe "#application_fee" do
    it "parses the application fee as an object" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg")
        .to_return(status: 200, body: get_complete_payment_json)

      payment = Mollie::Payment.get("tr_WDqYK6vllg")
      fee = payment.application_fee.as(Mollie::Payment::ApplicationFee)
      fee.amount.value.should eq(42.1)
      fee.amount.currency.should eq("EUR")
      fee.description.should eq("Example application fee")
    end
  end

  describe "#restrict_payment_methods_to_country" do
    it "restricts a payment to a country" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vlle")
        .to_return(status: 200, body: read_fixture("payments/get.json"))

      payment = Mollie::Payment.get("tr_WDqYK6vlle")
      payment.restrict_payment_methods_to_country.should eq("NL")
    end
  end

  describe ".create" do
    it "creates a payments" do
      configure_test_api_key
      body = %({"customerId":"cst_8wmqcHMN4U","amount":{"value":1.95,"currency":"EUR"}})
      WebMock.stub(:post, "https://api.mollie.com/v2/payments")
        .with(body: body)
        .to_return(status: 201, body: read_fixture("payments/post.json"))

      payment = Mollie::Payment.create(data: {
        customer_id: "cst_8wmqcHMN4U",
        amount:      {value: 1.95, currency: "EUR"},
      })
      payment.customer_id.should eq("cst_8wmqcHMN4U")
    end
  end
end
