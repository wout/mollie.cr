struct Mollie
  class Client
    API_ENDPOINT = "https://api.mollie.com"
    API_VERSION  = "v2"

    MODE_TEST = "test"
    MODE_LIVE = "live"

    property :api_key
    getter :api_endpoint

    def initialize(@api_key : String?)
      @api_endpoint = API_ENDPOINT
      @api_key = api_key
    end

    def api_endpoint=(api_endpoint : String)
      @api_endpoint = api_endpoint.chomp("/")
    end

    def api_path(api_method : String, id : String? = "")
      if api_method.starts_with?(API_ENDPOINT)
        URI.parse(api_method).path
      else
        "/#{API_VERSION}/#{api_method}/#{id}".chomp("/")
      end
    end

    def perform_http_call(
      http_method : String,
      api_method : String,
      id : String? = "",
      http_body : Hash(Symbol | String, String) = Hash(String, String).new,
      query : Hash(Symbol | String, String) = Hash(String, String).new
    )
      path = api_path(api_method, id)
      api_key = http_body.delete(:api_key) ||
                query.delete(:api_key) ||
                @api_key
      api_endpoint = http_body.delete(:api_endpoint) ||
                     query.delete(:api_endpoint) ||
                     @api_endpoint

      unless query.empty?
        camelized_query = Util.camelize_keys(query)
        path += "?#{Util.build_nested_query(camelized_query)}"
      end
    end

    def self.configuration
      @@configuration
    end

    def self.configuration=(configuration : Configuration)
      @@configuration = configuration
    end

    class Configuration
      property :api_key, :open_timeout, :read_timeout

      def initialize(
        @api_key : String = "",
        @open_timeout : Int = 60,
        @read_timeout : Int = 60
      )
      end
    end
  end
end
