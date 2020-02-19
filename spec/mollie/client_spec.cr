require "../spec_helper.cr"
require "../spec_helpers/client_helper.cr"

describe Mollie::Client do
  describe "#initialize" do
    it "stores the api key" do
      create_mollie_client.api_key
        .should be("test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM")
    end

    it "falls back to the globally configured api key" do
      Mollie::Config.api_key = "my_key"
      Mollie::Client.new.api_key.should eq("my_key")
    end

    it "can be initialized without an api key" do
      Mollie::Client.new.api_key.should be_nil
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

  describe "#http_headers" do
    it "contains mime type headers, bearer with token and version string" do
      headers = create_mollie_client.http_headers("Superpowers")
      headers["Accept"].should eq("application/json")
      headers["Content-Type"].should eq("application/json")
      headers["Authorization"].should eq("Bearer Superpowers")
      headers["User-Agent"].should eq(Mollie::Util.version_string)
    end
  end

  describe "#http_client" do
    it "returns a http client configured with certificate verification" do
      endpoint = URI.parse("https://example.com")
      client = create_mollie_client.http_client(endpoint)
      client.tls.should be_a(OpenSSL::SSL::Context::Client)
    end
  end

  describe "#perform_http_call" do
    it "fails if no api key is provided" do
      expect_raises(Mollie::MissingApiKeyException) do
        Mollie::Client.new.perform_http_call("GET", "my-method")
      end
    end

    it "fails with an invalid http method" do
      expect_raises(Mollie::MethodNotSupportedException) do
        create_mollie_client.perform_http_call("PUT", "my-method")
      end
    end

    it "has defaults to be able to perform a request" do
      WebMock.stub(:get, "https://api.mollie.com/v2/my-method")
        .with(headers: client_http_headers)
        .to_return(status: 200, body: "{}", headers: empty_string_hash)
      create_mollie_client.perform_http_call("GET", "my-method")
    end

    it "overrides defaults with given values" do
      query = {:api_key => "my_key", :api_endpoint => "https://some-host.com"}
      headers = client_http_headers({"Authorization" => "Bearer my_key"})
      WebMock.stub(:get, "https://some-host.com/v2/my-method")
        .with(headers: headers)
        .to_return(status: 200, body: "{}", headers: empty_string_hash)
      create_mollie_client
        .perform_http_call("GET", "my-method", nil, query)
      create_mollie_client
        .perform_http_call("GET", "my-method", nil, empty_string_hash, query)
    end

    it "converts query params to camel case" do
      query = {:my_param => "ok"}
      WebMock.stub(:get, "https://api.mollie.com/v2/my-method?myParam=ok")
        .with(headers: client_http_headers)
        .to_return(status: 200, body: "{}", headers: empty_string_hash)
      create_mollie_client
        .perform_http_call("GET", "my-method", nil, empty_string_hash, query)
    end

    it "returns a raw json string for successful requests" do
      body = {aap: "noot"}.to_json
      WebMock.stub(:get, "https://api.mollie.com/v2/good")
        .to_return(status: 200, body: body, headers: empty_string_hash)

      response = create_mollie_client
        .perform_http_call("GET", "good", nil, empty_string_hash)
      json = JSON.parse(response.to_s)
      json["aap"].should eq("noot")
    end

    it "returns an empty string for a response without content" do
      WebMock.stub(:get, "https://api.mollie.com/v2/empty")
        .to_return(status: 204, headers: empty_string_hash)

      response = create_mollie_client
        .perform_http_call("GET", "empty", nil, empty_string_hash)
      response.should eq("")
    end

    it "raises request exceptions" do
      WebMock.stub(:post, "https://api.mollie.com/v2/my-method")
        .with(headers: client_http_headers)
        .to_return(status: 401, body: example_error_response)

      expect_raises(Mollie::RequestException) do
        create_mollie_client.perform_http_call("POST", "my-method")
      end
    end

    it "raises request exceptions" do
      WebMock.stub(:post, "https://api.mollie.com/v2/no-method")
        .with(body: "{}", headers: client_http_headers)
        .to_return(status: 404, body: example_not_found_response)

      expect_raises(Mollie::ResourceNotFoundException) do
        create_mollie_client.perform_http_call("POST", "no-method")
      end
    end
  end

  describe ".instance" do
    it "returns a new instance" do
      Mollie::Client.instance.should be_a(Mollie::Client)
    end

    it "never initializes another new instance" do
      instance = Mollie::Client.instance
      Mollie::Client.instance.should be(instance)
    end
  end

  describe ".with_api_key" do
    it "returns the instance for a given api key" do
      client_1 = Mollie::Client.new("key_1")
      client_2 = Mollie::Client.new("key_2")
      Mollie::Client.with_api_key("key_1").should be(client_1)
      Mollie::Client.with_api_key("key_2").should be(client_2)
    end

    it "never initializes another instance for the given api key" do
      client = Mollie::Client.with_api_key("mastaba")
      Mollie::Client.with_api_key("mastaba").should be(client)
    end
  end
end
