require "../spec_helper.cr"

def test_permission
  Mollie::Permission.from_json(read_fixture("permissions/get.json"))
end

describe Mollie::Permission do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "is linkable" do
      test_permission.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required fields" do
      test_permission.description.should eq("View your payments")
      test_permission.granted.should be_true
      test_permission.id.should eq("payments.read")
    end
  end
end
