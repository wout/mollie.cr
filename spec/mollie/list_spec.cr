require "../spec_helper.cr"
require "../spec_helpers/list_helper.cr"

describe Mollie::List do
  describe ".from_json" do
    it "converts an embedded list of items to an array" do
      list = Mollie::List(Mollie::Mastaba).from_json(mastaba_list_json)
      list.items.should be_a(Array(Mollie::Mastaba))
      list.items.size.should eq(2)
      list.items.first.id.should eq("tr_1")
      list.items.last.id.should eq("tr_2")
    end
  end

  describe "enumerable methods" do
    it "forwards all missing methods items" do
      list = Mollie::List(Mollie::Mastaba).from_json(mastaba_list_json)
      list.size.should be_a(Int32)
      list[0].should be_a(Mollie::Mastaba)
      list[100]?.should be_nil
    end
  end
end

struct Mollie
  struct Mastaba < Base
    getter id : String?
  end
end
