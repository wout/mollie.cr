require "../spec_helper.cr"

def test_customer
  Mollie::Customer.from_json(read_fixture("customers/get.json"))
end

describe Mollie::Customer do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "contain links" do
      test_customer.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_customer.id.should eq("cst_kEn1PlbGa")
      test_customer.mode.should eq("test")
      test_customer.name.should eq("Customer A")
      test_customer.email.should eq("customer@example.org")
      test_customer.locale.should eq("nl_NL")
      test_customer.metadata.should be_a(HSBFIS?)
      test_customer.metadata.should be_nil
      test_customer.created_at.should eq(Time.parse_iso8601("2018-04-06T13:23:21.0Z"))
    end
  end

  describe "#mandates" do
    it "fetches the mandates" do
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/mandates")
        .to_return(status: 200, body: read_fixture("mandates/all.json"))

      test_customer.mandates.first.id.should eq("mdt_AcQl5fdL4h")
    end
  end

  describe "#payments" do
    it "fetches the payments" do
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/payments")
        .to_return(status: 200, body: read_fixture("payments/all.json"))

      test_customer.payments.first.id.should eq("tr_WDqYK6vllg")
    end
  end

  describe "#subscriptions" do
    it "fetches the subscriptions" do
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/subscriptions")
        .to_return(status: 200, body: read_fixture("subscriptions/all.json"))

      test_customer.subscriptions.first.id.should eq("sub_rVKGtNd6s3")
    end
  end
end
