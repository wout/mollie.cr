require "../spec_helper.cr"
require "../spec_helpers/exception_helper.cr"

def test_exception
  Mollie::RequestException.from_json(example_error_response_json)
end

describe Mollie::RequestException do
  describe "#initialize" do
    it "serializes json" do
      test_exception.status.should eq(401)
      test_exception.title.should eq("Unauthorized Request")
      test_exception.detail.should eq("Missing authentication, or failed to authenticate")
      test_exception.field.should eq("test-field")
      test_exception.links.should be_a(Links)
    end
  end

  describe "#message" do
    it "compiles a message based on api response" do
      test_exception.to_s.should start_with("401 Unauthorized Request")
      test_exception.to_s.should contain("Missing authentication")
      test_exception.to_s.should end_with("or failed to authenticate")
    end
  end

  describe "#to_s" do
    it "is an alias for message" do
      test_exception.to_s.should eq(test_exception.message)
    end
  end
end
