require "../spec_helper.cr"

describe Mollie::RequestException do
  describe "#initialize" do
    it "serializes json" do
      exception = Mollie::RequestException.from_json(example_error_response)
      exception.status.should eq(401)
      exception.title.should eq("Unauthorized Request")
      exception.detail.should eq("Missing authentication, or failed to authenticate")
      exception.field.should eq("test-field")
      exception._links.should be_a(Hash(String, Hash(String, String)))
    end
  end

  describe "#to_s" do
    it "description" do
      exception = Mollie::RequestException.from_json(example_error_response)
      exception.to_s.should start_with("401 Unauthorized Request")
      exception.to_s.should contain("Missing authentication")
      exception.to_s.should end_with("or failed to authenticate")
    end
  end
end
