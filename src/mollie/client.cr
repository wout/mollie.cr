struct Mollie
  class Client
    API_ENDPOINT = "https://api.mollie.com"
    API_VERSION  = "v2"

    MODE_TEST = "test"
    MODE_LIVE = "live"

    property :api_key
    getter :api_endpoint

    def initialize(api_key : String? = nil)
      @api_endpoint = API_ENDPOINT
      @api_key = api_key || Mollie::Config.api_key
    end

    def api_endpoint=(api_endpoint : String)
      @api_endpoint = api_endpoint.chomp("/")
    end

    def api_path(api_method : String, id : String? = nil)
      if api_method.starts_with?(API_ENDPOINT)
        URI.parse(api_method).path
      else
        "/#{API_VERSION}/#{api_method}/#{id}".chomp("/")
      end
    end

    def http_headers(api_key : String)
      HTTP::Headers{
        "Accept"        => "application/json",
        "Content-Type"  => "application/json",
        "Authorization" => "Bearer #{api_key}",
        "User-Agent"    => Util.version_string,
      }
    end

    def http_client(uri : URI)
      ca_cert = File.expand_path("../cacert.pem", File.dirname(__FILE__))
      tls_context = OpenSSL::SSL::Context::Client.new
      tls_context.ca_certificates = ca_cert
      client = HTTP::Client.new(uri, tls: tls_context)
      client.read_timeout = Mollie::Config.read_timeout
      client.connect_timeout = Mollie::Config.open_timeout
      client
    end

    def perform_http_call(
      http_method : String,
      api_method : String,
      id : String? = nil,
      http_body : Hash(Symbol | String, String) = Hash(String, String).new,
      query : Hash(Symbol | String, String) = Hash(String, String).new
    )
      api_key = http_body.delete(:api_key) || query.delete(:api_key) ||
                @api_key || Mollie::Config.api_key
      api_endpoint = http_body.delete(:api_endpoint) ||
                     query.delete(:api_endpoint) ||
                     @api_endpoint

      unless api_key
        raise Mollie::MissingApiKeyException.new("Missing API key")
      end

      path = api_path(api_method, id)
      unless query.empty?
        nested_query = Util.build_nested_query(Util.camelize_keys(query))
        path += "?#{nested_query}"
      end

      client = http_client(URI.parse(api_endpoint))
      headers = http_headers(api_key: api_key)

      begin
        case http_method
        when "GET"
          response = client.get(path, headers: headers)
        when "POST", "PATCH", "DELETE"
        else
        end
      rescue e : IO::Timeout
        # puts e.message
      end
    end
  end
end
