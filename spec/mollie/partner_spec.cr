require "../spec_helper.cr"

def test_partner
  Mollie::Partner.from_json(read_fixture("partners/get.json"))
end

describe Mollie::Partner do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "is linkable" do
      test_partner.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_partner.partner_type.should eq("signuplink")
      test_partner.is_commission_partner.should be_false
      test_partner.partner_contract_signed_at
        .should eq(Time.parse_iso8601("2018-03-20T13:13:37+00:00"))
      test_partner.partner_contract_update_available.should be_false
    end
  end

  describe "#type" do
    it "is an alias for partner_type" do
      test_partner.type.should eq("signuplink")
    end
  end

  describe "#commission_partner?" do
    it "returns false when not a commission partner" do
      test_partner.commission_partner?.should be_false
    end
  end

  describe "#contract_update_available?" do
    it "returns false when no update available" do
      test_partner.contract_update_available?.should be_false
    end
  end

  describe "#signuplink" do
    it "returns the signup link url" do
      test_partner.signuplink
        .should eq("https://www.mollie.com/dashboard/signup/myCode?lang=en")
    end
  end
end
