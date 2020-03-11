require "../spec_helper.cr"

def test_orgganization
  Mollie::Organization.from_json(read_fixture("organizations/get.json"))
end

describe Mollie::Organization do
  describe "#links" do
    it "is linkable" do
      test_orgganization.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_orgganization.id.should eq("org_12345678")
      test_orgganization.name.should eq("Mollie B.V.")
      test_orgganization.email.should eq("info@mollie.com")
      test_orgganization.address.should be_a(Mollie::Organization::Address)
      test_orgganization.address.street_and_number.should eq("Keizersgracht 313")
      test_orgganization.address.postal_code.should eq("1016 EE")
      test_orgganization.address.city.should eq("Amsterdam")
      test_orgganization.address.country.should eq("NL")
      test_orgganization.registration_number.should eq("30204462")
      test_orgganization.vat_number.should eq("NL815839091B01")
    end
  end
end
