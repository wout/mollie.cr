module Mollie
  class Error < ::Exception; end

  class RequestError < Mollie::Error
    def initialize(@mapper : Mapper)
    end

    def self.from_json(json : String)
      new(Mapper.from_json(json))
    end

    delegate status, title, detail, field, links, to: @mapper

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

  class ResourceNotFoundError < Mollie::RequestError; end

  class MissingApiKeyError < Mollie::Error; end

  class RequestTimeoutError < Mollie::Error; end

  class MethodNotSupportedError < Mollie::Error; end
end
