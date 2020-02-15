require "../spec_helper.cr"
require "../spec_helpers/client_helper.cr"

describe "Mollie::Client" do
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
    it "has defaults to perform a request" do
      headers = {
        "Accept"        => "application/json",
        "Content-type"  => "application/json",
        "Authorization" => "Bearer test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM",
        "User-Agent"    => Mollie::Util.version_string,
      }
      WebMock.stub(:any, "https://api.mollie.com/v2/my-method")
        .with(headers: headers)
        .to_return(status: 200, body: "{}", headers: empty_string_hash)
      create_mollie_client
        .perform_http_call("GET", "my-method", nil, empty_string_hash)
    end

    it "overrides defaults with given values" do
      headers = {
        "Accept"        => "application/json",
        "Content-type"  => "application/json",
        "Authorization" => "Bearer my_key",
        "User-Agent"    => Mollie::Util.version_string,
      }
      query = {:api_key => "my_key", :api_endpoint => "https://localhost"}
      WebMock.stub(:any, "https://localhost/v2/my-method")
        .with(headers: headers)
        .to_return(status: 200, body: "{}", headers: empty_string_hash)
      create_mollie_client
        .perform_http_call("GET", "my-method", nil, query)
      create_mollie_client
        .perform_http_call("GET", "my-method", nil, empty_string_hash, query)
    end
  end
end
