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

  describe ".nested_underscored_keys" do
    pending "converts hash keys to underscore recruisively" do
      nested = Mollie::Util.nested_underscored_keys({
        "someKey"     => "mastaba",
        "nestedItems" => {
          "nestedValue" => 1,
        },
      })
      nested["some_key"].should eq("mastaba")
      nested["nested_items"].should be_a(Hash)
      nested["nested_items"]["nested_value"].should eq(1)
    end

    it "converts an array of hashes recruisively" do
      nested = Mollie::Util.nested_underscored_keys([
        {"abSolUteLy" => "fab"},
      ])
      nested[0]["ab_sol_ute_ly"].should eq("fab")
    end

    it "does nothing for anything other than a hash or array" do
      nested = Mollie::Util.nested_underscored_keys(32)
      nested.should eq(32)
      nested = Mollie::Util.nested_underscored_keys(3.2)
      nested.should eq(3.2)
      nested = Mollie::Util.nested_underscored_keys("Renincarnation")
      nested.should eq("Renincarnation")
      nested = Mollie::Util.nested_underscored_keys(true)
      nested.should be_true
      nested = Mollie::Util.nested_underscored_keys(nil)
      nested.should be_nil
    end
  end

  describe ".build_nested_query" do
    context "given a hash" do
      it "returns a query param string" do
        query = Mollie::Util.build_nested_query({
          :name  => "Aap",
          :email => "noot@mies.wim",
        })
        query.should eq("name=Aap&email=noot%40mies.wim")
      end

      it "returns prefixed query param string" do
        query = Mollie::Util.build_nested_query({
          :name  => "Aap",
          :email => "noot@mies.wim",
        }, "zus")
        query.should eq("zus[name]=Aap&zus[email]=noot%40mies.wim")
      end

      it "accepts arrays as values" do
        query = Mollie::Util.build_nested_query({
          :name => "Aap",
          :list => %w[noot mies],
        }, "wim")
        query.should eq("wim[name]=Aap&wim[list][]=noot&wim[list][]=mies")
      end
    end

    context "given an array" do
      it "returns a query param string" do
        query = Mollie::Util.build_nested_query(%w[aap noot mies])
        query.should eq("[]=aap&[]=noot&[]=mies")
      end

      it "returns prefixed query param string" do
        query = Mollie::Util.build_nested_query(%w[aap noot mies], "zus")
        query.should eq("zus[]=aap&zus[]=noot&zus[]=mies")
      end
    end

    context "given a string" do
      it "returns a query param string" do
        query = Mollie::Util.build_nested_query("aap", "noot")
        query.should eq("noot=aap")
      end
    end

    context "given nil" do
      it "returns nil" do
        query = Mollie::Util.build_nested_query(nil)
        query.should be_nil
      end

      it "returns the prefix" do
        query = Mollie::Util.build_nested_query(nil, "aap")
        query.should eq("aap")
      end
    end
  end
end
