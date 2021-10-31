require "../spec_helper.cr"

describe Mollie::Util do
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
      link = "https://api.mollie.com/v2/customers/cst_4qqhO89gsT"
      Mollie::Util.extract_id(link).should eq("cst_4qqhO89gsT")
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

  describe ".camelize_key" do
    it "camelizes a string" do
      Mollie::Util.camelize_key("fab_u_lous").should eq("fabULous")
    end

    it "camelizes a symbol" do
      Mollie::Util.camelize_key(:symbols_are_cool).should eq("symbolsAreCool")
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

      it "accepts arrays with hashes" do
        query = Mollie::Util.build_nested_query({
          :name => "Aap",
          :list => [{:noot => "mies", :wim => 205}],
        }, "jet")
        query.should eq("jet[name]=Aap&jet[list][][noot]=mies&jet[list][][wim]=205")
      end
    end

    context "given a named tuple" do
      it "returns a query param string" do
        query = Mollie::Util.build_nested_query({
          name:  "Aap",
          email: "noot@mies.wim",
        })
        query.should eq("name=Aap&email=noot%40mies.wim")
      end

      it "returns prefixed query param string" do
        query = Mollie::Util.build_nested_query({
          name:  "Aap",
          email: "noot@mies.wim",
        }, "zus")
        query.should eq("zus[name]=Aap&zus[email]=noot%40mies.wim")
      end

      it "accepts arrays as values" do
        query = Mollie::Util.build_nested_query({
          name: "Aap",
          list: %w[noot mies],
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

  describe ".stringify_keys" do
    it "converts hash keys to strings" do
      original = {:symbol => "Symbol", "string" => "String"}
      stringified = Mollie::Util.stringify_keys(original)
      stringified["symbol"].should eq("Symbol")
      stringified["string"].should eq("String")
    end

    it "accepts named tuples" do
      original = {symbol: "Symbol", "string": "String"}
      stringified = Mollie::Util.stringify_keys(original)
      stringified["symbol"].should eq("Symbol")
      stringified["string"].should eq("String")
    end
  end

  describe ".query_from_href" do
    it "extracts a query hash from a given href" do
      href = "https://api.mollie.com/v2/mastabas?from=tr_1&limit=1"
      query = Mollie::Util.query_from_href(href)
      query.should be_a(Mollie::HS2)
      query["from"].should eq("tr_1")
      query["limit"].should eq("1")
    end

    it "returns an empty hash if no query params are present" do
      href = "https://api.mollie.com/v2/mastabas"
      query = Mollie::Util.query_from_href(href)
      query.should eq(Mollie::HS2.new)
    end
  end

  describe ".amount_with_decimals" do
    it "returns the amount as string with correct decimals" do
      amount = 101.88557
      Mollie.config.currency_decimals["SEK"] = 4
      Mollie::Util.amount_with_decimals(amount, "EUR").should eq("101.89")
      Mollie::Util.amount_with_decimals(amount, "JPY").should eq("102")
      Mollie::Util.amount_with_decimals(amount, "SEK").should eq("101.8856")
    end
  end
end
