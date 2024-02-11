require "../spec_helper.cr"

def test_list
  Mollie::List(Mollie::Mastaba).from_json(read_fixture("list/example.json"))
end

describe Mollie::List do
  before_each do
    configure_test_api_key
  end

  describe "#next" do
    it "returns the next page" do
      WebMock.stub(:get, "https://api.mollie.com/v2/mastabas?from=tr_2&limit=1")
        .to_return(status: 200, body: read_fixture("list/example-next.json"))

      next_page = test_list.next
      next_page.should_not eq(test_list)
      next_page.size.should eq(2)
      next_page.first.id.should eq("tr_next_1")
      next_page.last.id.should eq("tr_next_2")
    end

    it "returns itself without a next page" do
      list = Mollie::List(Mollie::Mastaba)
        .from_json(read_fixture("list/example-without-pages.json"))
      list.next.should eq(list)
    end
  end

  describe "#previous" do
    it "returns the previous page" do
      WebMock.stub(:get, "https://api.mollie.com/v2/mastabas?from=tr_1&limit=1")
        .to_return(status: 200, body: read_fixture("list/example-previous.json"))

      previous_page = test_list.previous
      previous_page.should_not eq(test_list)
      previous_page.size.should eq(2)
      previous_page.first.id.should eq("tr_previous_1")
      previous_page.last.id.should eq("tr_previous_2")
    end

    it "returns itself without a previous page" do
      list = Mollie::List(Mollie::Mastaba)
        .from_json(read_fixture("list/example-without-pages.json"))
      list.previous.should eq(list)
    end
  end

  describe "#links" do
    it "contains links" do
      test_list.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "converts an embedded list of items to an array" do
      test_list.items.should be_a(Array(Mollie::Mastaba))
      test_list.items.size.should eq(2)
      test_list.items.first.id.should eq("tr_1")
      test_list.items.last.id.should eq("tr_2")
    end
  end

  describe "enumerable methods" do
    it "forwards all missing methods items" do
      test_list.size.should be_a(Int32)
      test_list[0].should be_a(Mollie::Mastaba)
      test_list[100]?.should be_nil
    end
  end
end

module Mollie
  struct Mastaba < Base::Resource
    getter id : String?
  end
end
