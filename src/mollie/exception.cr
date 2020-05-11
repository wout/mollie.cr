struct Mollie
  class Exception < Exception; end

  class RequestException < Mollie::Exception
    def initialize(@mapper : Mapper)
    end

    def self.from_json(json : String)
      new(Mapper.from_json(json))
    end

    {% begin %}
      {% for method in %w[status title detail field links] %}
        delegate {{method.id}}, to: @mapper
      {% end %}
    {% end %}

    def message
      "#{status} #{title}: #{detail}"
    end

    def to_s
      message
    end

    struct Mapper
      include JSON::Serializable

      getter status : Int32?
      getter title : String?
      getter detail : String?
      getter field : String?
      @[JSON::Field(key: "_links")]
      getter links : Links
    end
  end

  class ResourceNotFoundException < Mollie::RequestException; end

  class MissingApiKeyException < Mollie::Exception; end

  class RequestTimeoutException < Mollie::Exception; end

  class MethodNotSupportedException < Mollie::Exception; end
end
