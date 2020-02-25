require "../spec_helper.cr"
require "../spec_helpers/list_helper.cr"

describe Mollie::List do
  describe ".from_json" do
    it "converts an embedded list of items to an array" do
      list = Mollie::MastabaList.from_json(payment_list_json)
      list.should be_a(Array(Mollie::Mastaba))
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
