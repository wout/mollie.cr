require "../spec_helper.cr"

describe "Mollie::Util" do
  describe ".version_string" do
    it "returns a string with mollie shard, crystal and openssl versions" do
      mollie = Mollie::VERSION
      crystal = Crystal::VERSION
      openssl = LibSSL::OPENSSL_VERSION
      Mollie::Util.version_string
        .should eq("Mollie/#{mollie} Crystal/#{crystal} OpenSSL/#{openssl}")
    end
  end

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

  describe ".camelize_keys" do
    it "camelizes all keys in a hash" do
      camelized = Mollie::Util.camelize_keys({
        "key_with_underscores" => "first",
        "key/with/slashes"     => "second",
      })
      camelized["keyWithUnderscores"].should be("first")
      camelized["key::With::Slashes"].should be("second")
    end

    it "accepts a has with symbol keys" do
      camelized = Mollie::Util.camelize_keys({
        :key_with_underscores => "first",
      })
      camelized["keyWithUnderscores"].should be("first")
    end
  end
end
