require "../spec_helper.cr"
require "../spec_helpers/list_helper.cr"

alias HSHS2 = Hash(String, Hash(String, String))

describe Mollie::List do
  describe "#next" do
  end

  describe ".from_json" do
    it "converts an embedded list of items to an array" do
      list = Mollie::List(Mollie::Mastaba).from_json(mastaba_list_json)
      list.items.should be_a(Array(Mollie::Mastaba))
      list.items.size.should eq(2)
      list.items.first.id.should eq("tr_1")
      list.items.last.id.should eq("tr_2")
    end

    it "converts links to a hash" do
      list = Mollie::List(Mollie::Mastaba).from_json(mastaba_list_json)
      list.links.should be_a(HSHS2)
      href = (list.links || HSHS2.new).dig("self", "href")
      href.should eq("https://api.mollie.com/v2/mastabas?limit=5")
      href = (list.links || HSHS2.new).dig?("kansas", "href")
      href.should be_nil
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
