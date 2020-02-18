struct Mollie
  class Client
    API_ENDPOINT = "https://api.mollie.com"
    API_VERSION  = "v2"

    MODE_TEST = "test"
    MODE_LIVE = "live"

    METHODS = %w[GET POST PATCH DELETE]

    class_property instances = Hash(String, Mollie::Client).new
    property :api_key
    getter :api_endpoint

    def initialize(api_key : String? = nil)
      @api_endpoint = API_ENDPOINT
      @api_key = api_key || Mollie::Config.api_key
      @@instances[@api_key.to_s] = self unless @api_key.nil?
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
      unless METHODS.includes?(http_method)
        raise Mollie::MethodNotSupportedException.new(
          "Invalid HTTP Method #{http_method}")
      end

      api_key = http_body.delete(:api_key) || query.delete(:api_key) ||
                @api_key || Mollie::Config.api_key
      api_endpoint = http_body.delete(:api_endpoint) ||
                     query.delete(:api_endpoint) ||
                     @api_endpoint

      unless api_key
        raise Mollie::MissingApiKeyException.new(
          "Expected API key but none was provided")
      end

      path = api_path(api_method, id)
      unless query.empty?
        nested_query = Util.build_nested_query(Util.camelize_keys(query))
        path += "?#{nested_query}"
      end

      client = http_client(URI.parse(api_endpoint))
      headers = http_headers(api_key: api_key)

      begin
        if http_method == "GET"
          response = client.get(path, headers: headers)
        else
          http_body.delete_if { |_k, v| v.nil? }
          body = Util.camelize_keys(http_body).to_json
          response = client.exec(http_method, path, headers: headers, body: body)
        end
        render(response)
      rescue e : IO::Timeout
        raise Mollie::RequestTimeoutException.new(e.message)
      rescue e : Exception
        raise Mollie::Exception.new(e.message)
      end
    end

    private def render(response)
      # case response.status.code
      # when 200, 201
      #   # Util.nested_underscored_keys(JSON.parse(response.body))

      # when 204
      #   Hash.new # No Content
      # when 404
      #   json = JSON.parse(response.body)
      #   raise ResourceNotFoundError.new(json)
      # else
      #   json = JSON.parse(response.body)
      #   raise Mollie::RequestError.new(json)
      # end
    end

    def self.instance
      self.with_api_key(Mollie::Config.api_key.to_s)
    end

    def self.with_api_key(api_key : String)
      @@instances[api_key]? || new(api_key)
    end
  end
end
