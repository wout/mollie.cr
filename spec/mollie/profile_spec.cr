require "../spec_helper.cr"

def test_profile
  Mollie::Profile.from_json(read_fixture("profiles/get.json"))
end

describe Mollie::Profile do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "is linkable" do
      test_profile.links.should be_a(Mollie::Links)
    end
  end

  describe "CategoryCode enum" do
    it "tests positive against a given code" do
      Mollie::Profile::CategoryCode::FoodAndDrinks.value.should eq(5499)
      Mollie::Profile::CategoryCode::Other.value.should eq(0)
    end
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      test_profile.blocked?.should be_false
      test_profile.unverified?.should be_false
      test_profile.verified?.should be_true
    end
  end

  describe "boolean review status methods" do
    it "defines a boolean method per review status" do
      test_profile.review.pending?.should be_true
      test_profile.review.rejected?.should be_false
    end
  end

  describe ".from_json" do
    it "pulls the required fields" do
      test_profile.category_code.should eq(5399)
      test_profile.created_at.should eq(Time.parse_iso8601("2018-03-20T09:28:37+00:00"))
      test_profile.email.should eq("info@mywebsite.com")
      test_profile.id.should eq("pfl_v9hTwCvYqw")
      test_profile.mode.should eq("live")
      test_profile.name.should eq("My website name")
      test_profile.phone.should eq("+31208202070")
      review = test_profile.review
      review.should be_a(Mollie::Profile::Review)
      review.status.should eq("pending")
      test_profile.status.should eq("verified")
      test_profile.website.should eq("https://www.mywebsite.com")
    end
  end

  describe "#checkout_preview_url" do
    it "returns the preview url from links" do
      test_profile.checkout_preview_url.should eq(test_profile.link_for(:checkout_preview_url))
    end
  end

  describe "#chargebacks" do
    it "fetches the related chargebacks" do
      WebMock.stub(:get, "https://api.mollie.com/v2/chargebacks?profileId=pfl_v9hTwCvYqw")
        .to_return(status: 200, body: read_fixture("chargebacks/list.json"))

      test_profile.chargebacks.first.id.should eq("chb_n9z0tp")
    end
  end

  describe "#methods" do
    it "fetches the related methods" do
      WebMock.stub(:get, "https://api.mollie.com/v2/methods?profileId=pfl_v9hTwCvYqw")
        .to_return(status: 200, body: read_fixture("methods/list.json"))

      test_profile.methods.first.id.should eq("ideal")
    end
  end

  describe "#payments" do
    it "fetches the related payments" do
      WebMock.stub(:get, "https://api.mollie.com/v2/payments?profileId=pfl_v9hTwCvYqw")
        .to_return(status: 200, body: read_fixture("payments/list.json"))

      test_profile.payments.first.id.should eq("tr_7UhSN1zuXS")
    end
  end

  describe "#refunds" do
    it "fetches the related refunds" do
      WebMock.stub(:get, "https://api.mollie.com/v2/refunds?profileId=pfl_v9hTwCvYqw")
        .to_return(status: 200, body: read_fixture("refunds/list.json"))

      test_profile.refunds.first.id.should eq("re_4qqhO89gsT")
    end
  end
end
