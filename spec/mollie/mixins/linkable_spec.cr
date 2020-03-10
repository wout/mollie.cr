require "../../spec_helper.cr"

def test_linkable
  Mollie::LinkableObject.from_json(read_fixture("linkable/example.json"))
end

describe Mollie::Mixins::Linkable do
  describe "#links" do
    it "has links" do
      test_linkable.links.should be_a(Links)
      links = test_linkable.links
      links.dig("self", "href").should eq("https://api.mollie.com/v2/linkableobjects/lob_d5E44r2gq")
      links.dig?("order", "href").should be_nil
      links.dig("documentation", "href").should eq("https://docs.mollie.com/reference/v2/linkableobjects-api/get-linkableobject")
    end
  end

  describe "#link_for" do
    it "returns the link for a given key" do
      test_linkable.link_for("self").should eq("https://api.mollie.com/v2/linkableobjects/lob_d5E44r2gq")
    end

    it "allows a symbol key" do
      test_linkable.link_for(:self).should eq(test_linkable.link_for("self"))
    end

    it "fails when the link does not exist" do
      expect_raises(Exception) do
        test_linkable.link_for("other")
      end
    end
  end

  describe "#link_for?" do
    it "returns the link for a given key" do
      object = Mollie::LinkableObject.from_json(read_fixture("linkable/example-with-null.json"))
      object.link_for?("self").should eq("https://api.mollie.com/v2/linkableobjects/lob_d5E44r2gq")
    end

    it "allows a symbol key" do
      object = Mollie::LinkableObject.from_json(read_fixture("linkable/example-with-null.json"))
      object.link_for?(:self).should eq(object.link_for?("self"))
    end

    it "allows the link to be nil" do
      object = Mollie::LinkableObject.from_json(read_fixture("linkable/example-with-null.json"))
      object.link_for?("nothing").should be_nil
    end
  end

  describe "#id_from_link" do
    it "returns the id from a link for a given key" do
      test_linkable.id_from_link("self").should eq("lob_d5E44r2gq")
    end

    it "accepts a symbol key" do
      test_linkable.id_from_link(:self).should eq(test_linkable.id_from_link("self"))
    end

    it "fails when the link does not exist" do
      expect_raises(Exception) do
        test_linkable.id_from_link("unknown-resource")
      end
    end
  end

  describe "#id_from_link?" do
    it "returns the id from a link for a given key" do
      test_linkable.id_from_link?("self").should eq("lob_d5E44r2gq")
    end

    it "accepts a symbol key" do
      test_linkable.id_from_link?(:self).should eq(test_linkable.id_from_link?("self"))
    end

    it "allows the link to be nil" do
      test_linkable.id_from_link?("unknown-resource").should be_nil
    end
  end
end

struct Mollie
  struct LinkableObject < Base::Resource
    include Mollie::Mixins::Linkable
  end
end
