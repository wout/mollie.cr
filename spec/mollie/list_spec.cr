require "../spec_helper.cr"
require "../spec_helpers/list_helper.cr"

describe Mollie::List do
  describe ".from_json" do
    it "converts an embedded list of items to an array" do
      items = %({
        "id":"tr_21",
        "_embedded": [
          {"id":"tr_22"},
          {"id":"tr_23"}
        ]
      })

      list = Mollie::MastabaList.from_json(items)
      list.items.should be_a(Array(Mollie::Mastaba))
      list.items.size.should eq(2)
      list.items.first.id.should eq("tr_22")
      list.items.last.id.should eq("tr_23")
    end
  end
end

struct Mollie
  struct Mastaba < Base
    getter id : String?
  end

  struct MastabaList < List(Mollie::Mastaba)
  end
end
