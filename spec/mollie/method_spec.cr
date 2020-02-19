require "../spec_helper.cr"
require "../spec_helpers/method_helper.cr"

describe Mollie::Method do
  describe "Type enum" do
    describe "#to_s" do
      it "converts to lower case" do
        Mollie::Method::Type::ApplePay.to_s.should eq("applepay")
      end
    end
  end

  describe "description" do
  end
end
