require "../../spec_helper.cr"

def subject
  Mollie::Customer::Mandate.from_json(read_fixture("mandates/get.json"))
end

describe Mollie::Customer::Mandate do
  before_each do
    configure_test_api_key
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      subject.valid?.should be_true
      subject.invalid?.should be_false
      subject.pending?.should be_false
    end
  end

  describe "#links" do
    it "contain links" do
      subject.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      subject.id.should eq("mdt_h3gAaD5zP")
      subject.mode.should eq("test")
      subject.status.should eq("valid")
      subject.method.should eq("directdebit")
      details = subject.details.as(HSBFIS)
      details["consumer_name"].should eq("John Doe")
      details["consumer_account"].should eq("NL55INGB0000000000")
      details["consumer_bic"].should eq("INGBNL2A")
      reference = subject.mandate_reference
      reference.should be_a(String?)
      reference.as(String).should eq("YOUR-COMPANY-MD1380")
      subject.signature_date.should eq("2018-05-07")
      subject.created_at.should eq(Time.parse_iso8601("2018-05-07T10:49:08+00:00"))
    end
  end

  describe "#customer" do
    it "fetches the customer" do
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/mandates/mdt_h3gAaD5zP")
        .to_return(status: 200, body: read_fixture("mandates/get.json"))
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa")
        .to_return(status: 200, body: read_fixture("customers/get.json"))

      mandate = Mollie::Customer::Mandate.get("mdt_h3gAaD5zP", {customer_id: "cst_kEn1PlbGa"})
      mandate.customer.id.should eq("cst_kEn1PlbGa")
    end
  end
end
