require "../spec_helper.cr"

def test_terminal
  Mollie::Terminal.from_json(read_fixture("terminals/get.json"))
end

describe Mollie::Terminal do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "is linkable" do
      test_terminal.links.should be_a(Mollie::Links)
    end
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      test_terminal.pending?.should be_false
      test_terminal.active?.should be_true
      test_terminal.inactive?.should be_false
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_terminal.id.should eq("term_7MgL5twpFAM8qa")
      test_terminal.profile_id.should eq("pfl_QkEhN94Ba")
      test_terminal.status.should eq("active")
      test_terminal.brand.should eq("PAX")
      test_terminal.model.should eq("A920")
      test_terminal.serial_number.should eq("1234567890")
      test_terminal.currency.should eq("EUR")
      test_terminal.description.should eq("Terminal #12345")
      test_terminal.created_at.should eq(Time.parse_iso8601("2022-02-12T11:58:35+00:00"))
      test_terminal.updated_at.should eq(Time.parse_iso8601("2022-11-15T13:32:11+00:00"))
      test_terminal.deactivated_at.should be_nil
    end
  end
end
