require "../spec_helper.cr"
require "../spec_helpers/list_helper.cr"

describe Mollie::List do
  describe "#next" do
    it "returns the next page" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/mastabas?from=tr_2&limit=1")
        .to_return(status: 200, body: mastaba_next_list_json)

      list = Mollie::List(Mollie::Mastaba).from_json(mastaba_list_json)
      next_page = list.next
      next_page.should_not eq(list)
      next_page.size.should eq(2)
      next_page.first.id.should eq("tr_next_1")
      next_page.last.id.should eq("tr_next_2")
    end

    it "returns itself without a next page" do
      list = Mollie::List(Mollie::Mastaba)
        .from_json(mastaba_list_without_pages_json)
      list.next.should eq(list)
    end
  end

  describe "#previous" do
    it "returns the previous page" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/mastabas?from=tr_1&limit=1")
        .to_return(status: 200, body: mastaba_previous_list_json)

      list = Mollie::List(Mollie::Mastaba).from_json(mastaba_list_json)
      previous_page = list.previous
      previous_page.should_not eq(list)
      previous_page.size.should eq(2)
      previous_page.first.id.should eq("tr_previous_1")
      previous_page.last.id.should eq("tr_previous_2")
    end

    it "returns itself without a previous page" do
      list = Mollie::List(Mollie::Mastaba)
        .from_json(mastaba_list_without_pages_json)
      list.previous.should eq(list)
    end
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
      href = list.links.as(HSHS2).dig("self", "href")
      href.should eq("https://api.mollie.com/v2/mastabas?limit=5")
      href = list.links.as(HSHS2).dig?("kansas", "href")
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
  struct Mastaba < Base::Resource
    getter id : String?
  end
end
