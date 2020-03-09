require "../../spec_helper.cr"

describe Mollie::Customer::Mandate do
  describe "Status enum" do
    describe "#to_s" do
      it "converts to lower case" do
        Mollie::Customer::Mandate::Status::Valid.to_s.should eq("valid")
      end
    end

    describe "#==" do
      it "tests against a lower case string" do
        (Mollie::Customer::Mandate::Status::Pending == "pending").should be_true
      end
    end
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      mandate = Mollie::Customer::Mandate.from_json(read_fixture("mandates/get.json"))
      mandate.valid?.should be_true
      mandate.invalid?.should be_false
      mandate.pending?.should be_false
    end
  end

  describe "#links" do
    it "contain links" do
      mandate = Mollie::Customer::Mandate.from_json(read_fixture("mandates/get.json"))
      mandate.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      mandate = Mollie::Customer::Mandate.from_json(read_fixture("mandates/get.json"))
      mandate.id.should eq("mdt_h3gAaD5zP")
      mandate.mode.should eq("test")
      mandate.status.should eq("valid")
      mandate.method.should eq("directdebit")
      details = mandate.details.as(HSBFIS)
      details["consumer_name"].should eq("John Doe")
      details["consumer_account"].should eq("NL55INGB0000000000")
      details["consumer_bic"].should eq("INGBNL2A")
      reference = mandate.mandate_reference
      reference.should be_a(String?)
      reference.as(String).should eq("YOUR-COMPANY-MD1380")
      mandate.signature_date.should eq("2018-05-07")
      mandate.created_at.should eq(Time.parse_rfc3339("2018-05-07T10:49:08+00:00"))
    end
  end

  describe "#customer" do
    it "fetches the customer" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa/mandates/mdt_h3gAaD5zP")
        .to_return(status: 200, body: read_fixture("mandates/get.json"))
      WebMock.stub(:get, "https://api.mollie.com/v2/customers/cst_kEn1PlbGa")
        .to_return(status: 200, body: read_fixture("customers/get.json"))

      mandate = Mollie::Customer::Mandate.get("mdt_h3gAaD5zP", {customer_id: "cst_kEn1PlbGa"})
      mandate.customer.id.should eq("cst_kEn1PlbGa")
    end
  end
end
