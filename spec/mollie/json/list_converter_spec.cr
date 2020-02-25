require "../../spec_helper.cr"

describe Mollie::Json::ListConverter do
  describe ".collection_key" do
    it "returns a pluralized version of the list's item type" do
      key = Mollie::Json::ListConverter(Mollie::Mastaba).collection_key
      key.should eq("mastabas")
    end
  end
end

struct Mollie
  struct Mastaba < Base
    getter id : String?
  end
end
