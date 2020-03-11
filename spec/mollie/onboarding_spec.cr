require "../spec_helper.cr"

def test_onboarding
  Mollie::Onboarding.from_json(read_fixture("onboarding/get.json"))
end

describe Mollie::Onboarding do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "is linkable" do
      test_onboarding.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required fields" do
      test_onboarding.can_receive_payments.should be_true
      test_onboarding.can_receive_settlements.should be_true
      test_onboarding.name.should eq("Mollie B.V.")
      test_onboarding.signed_up_at.should eq(Time.parse_iso8601("2018-12-20T10:49:08+00:00"))
      test_onboarding.status.should eq("completed")
    end
  end

  describe "#organization" do
    it "fetches the related organization" do
      WebMock.stub(:get, "https://api.mollie.com/v2/organization/org_12345678")
        .to_return(status: 200, body: read_fixture("organizations/get.json"))

      test_onboarding.organization.id.should eq("org_12345678")
    end
  end

  describe "#dashboard" do
    it "returns the dashboard url" do
      test_onboarding.dashboard.should eq(test_onboarding.link_for(:dashboard))
    end
  end

  describe ".me" do
    it "fetches my profile" do
      WebMock.stub(:get, "https://api.mollie.com/v2/onboarding/me")
        .to_return(status: 200, body: read_fixture("onboarding/get.json"))

      me = Mollie::Onboarding.me
      me.should be_a(Mollie::Onboarding)
      me.name.should eq("Mollie B.V.")
    end
  end

  describe ".submit" do
    it "submits onboarding data" do
      WebMock.stub(:post, "https://api.mollie.com/v2/onboarding/me")
        .to_return(status: 204, body: "")

      Mollie::Onboarding.submit({
        organization: {
          name:    "Mollie B.V.",
          address: {
            streetAndNumber: "Keizersgracht 313",
            postalCode:      "1018 EE",
            city:            "Amsterdam",
            country:         "NL",
          },
          registrationNumber: "30204462",
          vatNumber:          "NL815839091B01",
        },
        profile: {
          name:         "Mollie",
          url:          "https://www.mollie.com",
          email:        "info@mollie.com",
          phone:        "+31208202070",
          categoryCode: 6012,
        },
      }).should be_empty
    end
  end
end
