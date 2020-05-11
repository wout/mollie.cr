require "../spec_helper.cr"

def test_organization
  Mollie::Organization.from_json(read_fixture("organizations/get.json"))
end

describe Mollie::Organization do
  describe "#links" do
    it "is linkable" do
      test_organization.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_organization.id.should eq("org_12345678")
      test_organization.name.should eq("Mollie B.V.")
      test_organization.email.should eq("info@mollie.com")
      test_organization.address.should be_a(Mollie::Organization::Address)
      test_organization.address.street_and_number.should eq("Keizersgracht 313")
      test_organization.address.postal_code.should eq("1016 EE")
      test_organization.address.city.should eq("Amsterdam")
      test_organization.address.country.should eq("NL")
      test_organization.registration_number.should eq("30204462")
      test_organization.vat_number.should eq("NL815839091B01")
    end
  end

  describe "#dashboard_url" do
    it "extracts the dasboard url" do
      test_organization.dashboard_url
        .should eq("https://mollie.com/dashboard/org_12345678")
    end
  end
end
