require "../spec_helper.cr"

def test_subscription
  Mollie::Subscription.from_json(read_fixture("subscriptions/get.json"))
end

describe Mollie::Subscription do
  before_each do
    configure_test_api_key
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      test_subscription.active?.should be_true
      test_subscription.pending?.should be_false
      test_subscription.canceled?.should be_false
      test_subscription.suspended?.should be_false
      test_subscription.completed?.should be_false
    end
  end

  describe "#links" do
    it "contain links" do
      test_subscription.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_subscription.id.should eq("sub_rVKGtNd6s3")
      test_subscription.mode.should eq("live")
      test_subscription.created_at.should eq(Time.parse_iso8601("2016-06-01T12:23:34+00:00"))
      test_subscription.canceled_at.should be_a(Time?)
      test_subscription.status.should eq("active")
      test_subscription.amount.should be_a(Mollie::Amount)
      test_subscription.times.should eq(4)
      test_subscription.times_remaining.should eq(4)
      test_subscription.start_date.should eq("2016-06-01")
      test_subscription.next_payment_date.should eq("2016-09-01")
      test_subscription.description.should eq("Quarterly payment")
      test_subscription.method.should be_nil
      test_subscription.mandate_id.should eq("mdt_38HS4fsS")
      test_subscription.webhook_url.should eq("https://webshop.example.org/payments/webhook")
      test_subscription.metadata.should be_a(Mollie::HSBFIS)
      test_subscription.application_fee.should be_a(Mollie::Subscription::ApplicationFee?)
      test_subscription.interval.should eq("3 months")
    end

    it "optionally pulls the application fee" do
      subscription = Mollie::Subscription.from_json(read_fixture("subscriptions/get-with-application-fee.json"))
      fee = subscription.application_fee.as(Mollie::Subscription::ApplicationFee)
      fee.description.should eq("Example application fee")
    end
  end

  describe "#customer" do
    it "gets the linked customer" do
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/subscriptions/sub_rVKGtNd6s3")
        .to_return(status: 200, body: read_fixture("subscriptions/get-with-customer-id.json"))
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa")
        .to_return(body: read_fixture("customers/get.json"))

      subscription = Mollie::Customer::Subscription.get("sub_rVKGtNd6s3", {customer_id: "cst_kEn1PlbGa"})
      subscription.customer.as(Mollie::Customer).id.should eq("cst_kEn1PlbGa")
    end

    it "is nilable" do
      WebMock.stub(:get, "https://api.mollie.com/v2/subscriptions/sub_rVKGtNd6s3")
        .to_return(status: 200, body: read_fixture("subscriptions/get.json"))

      subscription = Mollie::Customer::Subscription.get("sub_rVKGtNd6s3")
      subscription.customer.should be_nil
    end
  end

  describe "#payments" do
    it "fetches all payments related to this subscription" do
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/subscriptions/sub_rVKGtNd6s3")
        .to_return(status: 200, body: read_fixture("subscriptions/get.json"))
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_stTC2WHAuS/subscriptions/sub_rVKGtNd6s3/payments")
        .to_return(status: 200, body: read_fixture("payments/all.json"))

      subscription = Mollie::Customer::Subscription.get("sub_rVKGtNd6s3", {customer_id: "cst_kEn1PlbGa"})
      subscription.payments.should be_a(Mollie::List(Mollie::Customer::Payment))
    end

    it "is nilable" do
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/subscriptions/sub_rVKGtNd6s5")
        .to_return(status: 200, body: read_fixture("subscriptions/get-without-payments-link.json"))

      subscription = Mollie::Customer::Subscription.get("sub_rVKGtNd6s5", {customer_id: "cst_kEn1PlbGa"})
      subscription.payments.should be_nil
    end
  end
end
