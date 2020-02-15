require "../spec_helper.cr"
require "../spec_helpers/client_helper.cr"

describe "Mollie::Client" do
  describe ".version_string" do
    it "compiles a string with mollie shard, crystal and openssl versions" do
      mollie = Mollie::VERSION
      crystal = Crystal::VERSION
      openssl = LibSSL::OPENSSL_VERSION
      Mollie::Client.version_string
        .should eq("Mollie/#{mollie} Crystal/#{crystal} OpenSSL/#{openssl}")
    end
  end

  describe "#initialize" do
    it "stores the api key" do
      create_mollie_client.api_key
        .should be("test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM")
    end
  end

  describe "#api_endpoint=" do
    it "ensures the api endpoint is stored without trailing slash" do
      client = create_mollie_client
      client.api_endpoint = "http://my.endpoint/"
      client.api_endpoint.should eq("http://my.endpoint")
    end
  end

  describe "#api_path" do
    it "prepends the api version" do
      create_mollie_client.api_path("my-method", "my-id")
        .should eq("/v2/my-method/my-id")
    end

    it "treats the id parameter as optional" do
      create_mollie_client.api_path("my-method")
        .should eq("/v2/my-method")
      create_mollie_client.api_path("my-method", nil)
        .should eq("/v2/my-method")
    end

    it "accepts a full api uri" do
      create_mollie_client.api_path("https://api.mollie.com/v2/my-method")
        .should eq("/v2/my-method")
    end

    it "does not append the given id with a full api uri" do
      create_mollie_client.api_path("https://api.mollie.com/v2/my-method", "id")
        .should eq("/v2/my-method")
    end
  end

  describe "#perform_http_call" do
  end
end
