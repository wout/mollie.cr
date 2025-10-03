module Mollie
  struct Client
    API_ENDPOINT = "https://api.mollie.com"
    API_VERSION  = "v2"

    MODE_TEST = "test"
    MODE_LIVE = "live"

    METHODS = %w[GET POST PATCH DELETE]

    getter api_key : String?
    getter api_endpoint : String

    def initialize(
      @api_key : String? = Mollie.config.api_key,
      api_endpoint : String = API_ENDPOINT,
    )
      @api_endpoint = api_endpoint.chomp("/")

      if @api_key
        State.instances[@api_key.as(String)] = self unless @api_key.nil?
      else
        raise MissingApiKeyException.new(
          "Expected API key but none was provided")
      end
    end

    def api_path(api_method : String, id : String? = nil)
      if api_method.starts_with?(API_ENDPOINT)
        URI.parse(api_method).path
      else
        "/#{API_VERSION}/#{api_method}/#{id}".chomp("/")
      end
    end

    def perform_http_call(
      http_method : String,
      api_method : String,
      id : String? = nil,
      http_body : Hash | NamedTuple = HS2.new,
      query : Hash | NamedTuple = HS2.new,
    )
      unless METHODS.includes?(http_method)
        raise MethodNotSupportedException.new(
          "Invalid HTTP Method #{http_method}")
      end

      path = api_path(api_method, id)
      unless query.empty?
        nested_query = Util.build_nested_query(Util.camelize_keys(query))
        path += "?#{nested_query}"
      end

      client = http_client(URI.parse(api_endpoint.to_s))
      headers = http_headers(api_key: api_key.to_s)

      begin
        if http_method == "GET"
          response = client.get(path, headers: headers)
        else
          http_body = http_body.to_h.reject! { |_, v| v.nil? }
          body = Util.camelize_keys(http_body).to_json
          response = client.exec(http_method, path, headers: headers, body: body)
        end
        render(response)
      rescue e : IO::TimeoutError
        raise RequestTimeoutException.new(e.message)
      rescue e : IO::EOFError
        raise Exception.new(e.message)
      end
    end

    private def http_headers(api_key : String)
      HTTP::Headers{
        "Accept"        => "application/json",
        "Content-Type"  => "application/json",
        "Authorization" => "Bearer #{api_key}",
        "User-Agent"    => Util.version_string,
      }
    end

    private def http_client(uri : URI)
      ca_cert = File.expand_path("../cacert.pem", File.dirname(__FILE__))
      tls_context = OpenSSL::SSL::Context::Client.new
      tls_context.ca_certificates = ca_cert
      client = HTTP::Client.new(uri, tls: tls_context)
      client.read_timeout = Mollie.config.read_timeout
      client.connect_timeout = Mollie.config.open_timeout
      client
    end

    private def render(response : HTTP::Client::Response)
      case response.status_code
      when 200, 201
        response.body
      when 204
        ""
      when 404
        raise ResourceNotFoundException.from_json(response.body)
      else
        raise RequestException.from_json(response.body)
      end
    end

    def self.instance
      self.with_api_key(Mollie.config.api_key)
    end

    def self.with_api_key(api_key : String?)
      State.instances[api_key]? || new(api_key)
    end

    def self.with_api_key(api_key : String?, &)
      yield(Mollie::Sandbox.new(with_api_key(api_key)))
    end
  end
end
