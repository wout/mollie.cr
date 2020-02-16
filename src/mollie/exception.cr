struct Mollie
  class Exception < Exception; end

  class RequestException < Mollie::Exception
    property status : Int32?

    def initialize(@error : JSON::Any)
    end
  end

  class MissingApiKeyException < Mollie::Exception; end

  class RequestTimeoutException < Mollie::Exception; end

  class MethodNotSupportedException < Mollie::Exception; end
end
