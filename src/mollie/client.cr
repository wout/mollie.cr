struct Mollie
  class Client
    API_ENDPOINT = "https://api.mollie.com"
    API_VERSION  = "v2"

    MODE_TEST = "test"
    MODE_LIVE = "live"

    @@version_string : String?

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

    def self.version_string
      if @@version_string.nil?
        mollie = "Mollie/" + Mollie::VERSION
        crystal = "Crystal/" + Crystal::VERSION
        openssl = "OpenSSL/" + LibSSL::OPENSSL_VERSION
        @@version_string = "#{mollie} #{crystal} #{openssl}"
      end
      @@version_string
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
