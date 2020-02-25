struct Mollie
  struct List(T) < Base
    macro list_converter
      Mollie::Json::ListConverter({{ T.id }})
    end

    @[JSON::Field(key: "_embedded", converter: list_converter)]
    getter items : Array(T)

    @[JSON::Field(key: "_links")]
    getter links : Hash(String, Hash(String, String))?

    forward_missing_to @items
  end
end
