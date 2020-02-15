require "../spec_helper.cr"

describe "Mollie::Util" do
  describe ".extract_id" do
    it "extracts the id" do
      links = {
        "customer" => {
          "href" => "https://api.mollie.com/v2/customers/cst_4qqhO89gsT",
          "type" => "application/hal+json",
        },
      }
      Mollie::Util.extract_id(links, "customer").should eq("cst_4qqhO89gsT")
    end

    it "does not extract the id with a missing link" do
      links = {
        "customer" => {
          "href" => "https://api.mollie.com/v2/customers/cst_4qqhO89gsT",
          "type" => "application/hal+json",
        },
      }
      Mollie::Util.extract_id(links, "unknown-resource").should be_nil
    end
  end
end
