struct Mollie
  class Exception < Exception; end

  class RequestException < Mollie::Exception
    JSON.mapping({
      status: Int32?,
      title:  String?,
      detail: String?,
      field:  String?,
      _links: Hash(String, Hash(String, String)),
    })

    def to_s
      "#{status} #{title}: #{detail}"
    end
  end

  class MissingApiKeyException < Mollie::Exception; end

  class RequestTimeoutException < Mollie::Exception; end

  class MethodNotSupportedException < Mollie::Exception; end
end
