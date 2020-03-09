struct Mollie
  class Exception < Exception; end

  class RequestException < Mollie::Exception
    JSON.mapping({
      status: Int32?,
      title:  String?,
      detail: String?,
      field:  String?,
      links:  {type: Links, key: "_links"},
    })

    def to_s
      "#{status} #{title}: #{detail}"
    end
  end

  class ResourceNotFoundException < Mollie::RequestException
  end

  class MissingApiKeyException < Mollie::Exception; end

  class RequestTimeoutException < Mollie::Exception; end

  class MethodNotSupportedException < Mollie::Exception; end
end
