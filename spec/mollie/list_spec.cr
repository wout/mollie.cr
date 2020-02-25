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

  describe ".each" do
    it "yields every item" do
      list = Mollie::List(Mollie::Mastaba).from_json(mastaba_list_json)
      count = 0
      list.each do |item|
        item.should be_a(Mollie::Mastaba)
        count += 1
      end
      count.should eq(2)
    end
  end

  describe ".size" do
    it "returns the number of items in the collection" do
      list = Mollie::List(Mollie::Mastaba).from_json(mastaba_list_json)
      list.size.should eq(2)
    end
  end

  describe ".[]" do
    it "returns an item at the given index" do
      list = Mollie::List(Mollie::Mastaba).from_json(mastaba_list_json)
      list[0].should be_a(Mollie::Mastaba)
    end
  end

  describe ".[]?" do
    it "returns for nothing if the index is out of range" do
      list = Mollie::List(Mollie::Mastaba).from_json(mastaba_list_json)
      list[100]?.should be_nil
    end
  end
end

struct Mollie
  struct Mastaba < Base
    getter id : String?
  end
end
