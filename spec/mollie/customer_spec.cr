require "../spec_helper.cr"

describe Mollie::Customer do
  describe "#links" do
    it "contain links" do
      customer = Mollie::Customer.from_json(read_fixture("customers/get.json"))
      customer.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      customer = Mollie::Customer.from_json(read_fixture("customers/get.json"))
      customer.id.should eq("cst_kEn1PlbGa")
      customer.mode.should eq("test")
      customer.name.should eq("Customer A")
      customer.email.should eq("customer@example.org")
      customer.locale.should eq("nl_NL")
      customer.metadata.should be_a(HSBFIS?)
      customer.metadata.should be_nil
      customer.created_at.should eq(Time.parse_iso8601("2018-04-06T13:23:21.0Z"))
    end
  end

  describe "#mandates" do
    it "fetches the mandates" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/mandates")
        .to_return(status: 200, body: read_fixture("mandates/all.json"))

      customer = Mollie::Customer.from_json(read_fixture("customers/get.json"))
      customer.mandates.first.id.should eq("mdt_AcQl5fdL4h")
    end
  end

  describe "#payments" do
    it "fetches the payments" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/payments")
        .to_return(status: 200, body: read_fixture("payments/all.json"))

      customer = Mollie::Customer.from_json(read_fixture("customers/get.json"))
      customer.payments.first.id.should eq("tr_WDqYK6vllg")
    end
  end

  describe "#subscriptions" do
    it "fetches the subscriptions" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/subscriptions")
        .to_return(status: 200, body: read_fixture("subscriptions/all.json"))

      customer = Mollie::Customer.from_json(read_fixture("customers/get.json"))
      customer.subscriptions.first.id.should eq("sub_rVKGtNd6s3")
    end
  end
end
