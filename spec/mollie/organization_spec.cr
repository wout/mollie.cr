require "../spec_helper.cr"

describe Mollie::Organization do
  describe "#links" do
    it "is linkable" do
      organization = Mollie::Organization.from_json(read_fixture("organizations/get.json"))
      organization.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      organization = Mollie::Organization.from_json(read_fixture("organizations/get.json"))
      organization.id.should eq("org_12345678")
      organization.name.should eq("Mollie B.V.")
      organization.email.should eq("info@mollie.com")
      organization.address.should be_a(Mollie::Organization::Address)
      organization.address.street_and_number.should eq("Keizersgracht 313")
      organization.address.postal_code.should eq("1016 EE")
      organization.address.city.should eq("Amsterdam")
      organization.address.country.should eq("NL")
      organization.registration_number.should eq("30204462")
      organization.vat_number.should eq("NL815839091B01")
    end
  end
end
