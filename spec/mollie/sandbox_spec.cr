require "../spec_helper.cr"

def sandbox_client
  Mollie::Client.new("proxy_in_a_sandbox")
end

def proxy_sandbox_headers
  {"Authorization" => "Bearer proxy_in_a_sandbox"}
end

def test_sandbox
  Mollie::Sandbox.new(sandbox_client)
end

describe Mollie::Sandbox do
  describe "#client" do
    it "returns the given client" do
      test_sandbox.client.should eq(sandbox_client)
    end
  end

  describe "#payment" do
    it "returns a proxy object which sandboxes requests to the given client" do
      test_sandbox.payment.should be_a(Mollie::Sandbox::Payment)
      test_sandbox.payment.client.should eq(sandbox_client)
    end

    it "proxies all" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments")
        .with(headers: proxy_sandbox_headers)
        .to_return(body: read_fixture("payments/list.json"))

      payments = test_sandbox.payment.all
      payments.should be_a(Mollie::List(Mollie::Payment))
      payments.first.id.should eq("tr_7UhSN1zuXS")
    end

    it "proxies get" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg")
        .with(headers: proxy_sandbox_headers)
        .to_return(body: read_fixture("payments/get.json"))

      test_sandbox.payment.get("tr_WDqYK6vllg").id.should eq("tr_WDqYK6vllg")
    end

    it "proxies create" do
      body = %({"amount":21.21,"currency":"GBP"})
      WebMock.stub(:post, "https://api.mollie.com/v2/payments")
        .with(body: body, headers: proxy_sandbox_headers)
        .to_return(body: read_fixture("payments/get.json"))

      payment = test_sandbox.payment.create({
        amount:   21.21,
        currency: "GBP",
      })
      payment.id.should eq("tr_WDqYK6vllg")
    end

    it "proxies update" do
      body = %({"amount":12.12,"currency":"EUR"})
      WebMock.stub(:patch, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg")
        .with(body: body, headers: proxy_sandbox_headers)
        .to_return(body: read_fixture("payments/get.json"))

      payment = test_sandbox.payment.update("tr_WDqYK6vllg", {
        amount:   12.12,
        currency: "EUR",
      })
      payment.id.should eq("tr_WDqYK6vllg")
    end

    it "proxies delete" do
      WebMock.stub(:delete, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg")
        .with(body: "{}", headers: proxy_sandbox_headers)
        .to_return(body: "")

      test_sandbox.payment.delete("tr_WDqYK6vllg").should eq("")
    end

    it "proxies cancel" do
      WebMock.stub(:delete, "https://api.mollie.com/v2/payments/tr_WDqYK6vllg")
        .with(body: "{}", headers: proxy_sandbox_headers)
        .to_return(body: "")

      test_sandbox.payment.cancel("tr_WDqYK6vllg").should eq("")
    end
  end

  describe "#chargeback" do
    it "returns a proxy object" do
      test_sandbox.chargeback.should be_a(Mollie::Sandbox::Chargeback)
    end
  end

  describe "#customer" do
    it "returns a proxy object" do
      test_sandbox.customer.should be_a(Mollie::Sandbox::Customer)
    end
  end

  describe "#customer_mandate" do
    it "returns a proxy object" do
      test_sandbox.customer_mandate.should be_a(Mollie::Sandbox::Customer::Mandate)
    end
  end

  describe "#customer_payment" do
    it "returns a proxy object" do
      test_sandbox.customer_payment.should be_a(Mollie::Sandbox::Customer::Payment)
    end
  end

  describe "#customer_subscription" do
    it "returns a proxy object" do
      test_sandbox.customer_subscription.should be_a(Mollie::Sandbox::Customer::Subscription)
    end
  end

  describe "#invoice" do
    it "returns a proxy object" do
      test_sandbox.invoice.should be_a(Mollie::Sandbox::Invoice)
    end
  end

  describe "#method" do
    it "returns a proxy object" do
      test_sandbox.method.should be_a(Mollie::Sandbox::Method)
    end
  end

  describe "#onboarding" do
    it "returns a proxy object" do
      test_sandbox.onboarding.should be_a(Mollie::Sandbox::Onboarding)
    end
  end

  describe "#order" do
    it "returns a proxy object" do
      test_sandbox.order.should be_a(Mollie::Sandbox::Order)
    end
  end

  describe "#order_line" do
    it "returns a proxy object" do
      test_sandbox.order_line.should be_a(Mollie::Sandbox::Order::Line)
    end
  end

  describe "#order_refund" do
    it "returns a proxy object" do
      test_sandbox.order_refund.should be_a(Mollie::Sandbox::Order::Refund)
    end
  end

  describe "#order_shipment" do
    it "returns a proxy object" do
      test_sandbox.order_shipment.should be_a(Mollie::Sandbox::Order::Shipment)
    end
  end

  describe "#organization" do
    it "returns a proxy object" do
      test_sandbox.organization.should be_a(Mollie::Sandbox::Organization)
    end
  end

  describe "#permission" do
    it "returns a proxy object" do
      test_sandbox.permission.should be_a(Mollie::Sandbox::Permission)
    end
  end

  describe "#payment_capture" do
    it "returns a proxy object" do
      test_sandbox.payment_capture.should be_a(Mollie::Sandbox::Payment::Capture)
    end
  end

  describe "#payment_chargeback" do
    it "returns a proxy object" do
      test_sandbox.payment_chargeback.should be_a(Mollie::Sandbox::Payment::Chargeback)
    end
  end

  describe "#payment_refund" do
    it "returns a proxy object" do
      test_sandbox.payment_refund.should be_a(Mollie::Sandbox::Payment::Refund)
    end
  end

  describe "#profile" do
    it "returns a proxy object" do
      test_sandbox.profile.should be_a(Mollie::Sandbox::Profile)
    end
  end

  describe "#refund" do
    it "returns a proxy object" do
      test_sandbox.refund.should be_a(Mollie::Sandbox::Refund)
    end
  end

  describe "#settlement" do
    it "returns a proxy object" do
      test_sandbox.settlement.should be_a(Mollie::Sandbox::Settlement)
    end
  end

  describe "#settlement_chargeback" do
    it "returns a proxy object" do
      test_sandbox.settlement_chargeback.should be_a(Mollie::Sandbox::Settlement::Chargeback)
    end
  end

  describe "#settlement_payment" do
    it "returns a proxy object" do
      test_sandbox.settlement_payment.should be_a(Mollie::Sandbox::Settlement::Payment)
    end
  end

  describe "#settlement_refund" do
    it "returns a proxy object" do
      test_sandbox.settlement_refund.should be_a(Mollie::Sandbox::Settlement::Refund)
    end
  end

  describe "#subscription" do
    it "returns a proxy object" do
      test_sandbox.subscription.should be_a(Mollie::Sandbox::Subscription)
    end
  end
end
