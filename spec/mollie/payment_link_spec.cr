require "../spec_helper.cr"

def test_payment_link
  Mollie::PaymentLink.from_json(read_fixture("payment-links/get.json"))
end

describe Mollie::PaymentLink do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "is linkable" do
      test_payment_link.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_payment_link.id.should eq("pl_4Y0eZitmBnQ6IDoMqZQKh")
      test_payment_link.mode.should eq("test")
      test_payment_link.profile_id.should eq("pfl_QkEhN94Ba")
      test_payment_link.description.should eq("Bicycle tires")
      test_payment_link.archived.should be_false
      test_payment_link.redirect_url.should eq("https://webshop.example.org/thanks")
      test_payment_link.webhook_url.should eq("https://webshop.example.org/payment-links/webhook/")
      test_payment_link.amount.should be_a(Mollie::Amount?)
      test_payment_link.amount.as(Mollie::Amount).value.should eq(24.95.to_big_d)
      test_payment_link.created_at.should eq(Time.parse_iso8601("2021-03-20T09:13:37+00:00"))
      test_payment_link.paid_at.should be_nil
      test_payment_link.expires_at.should eq(Time.parse_iso8601("2021-06-06T11:00:00+00:00"))
    end
  end

  describe "#archived?" do
    it "returns false when not archived" do
      test_payment_link.archived?.should be_false
    end
  end

  describe "#payment_link" do
    it "returns the payment link url" do
      test_payment_link.payment_link
        .should eq("https://paymentlink.mollie.com/payment/4Y0eZitmBnQ6IDoMqZQKh/")
    end
  end
end
