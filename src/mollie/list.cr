struct Mollie
  abstract struct List(T) < Base
    include Enumerable(T)

    macro list_converter
      Mollie::Json::ListConverter({{ T.id }})
    end

    @[JSON::Field(key: "_embedded", converter: list_converter)]
    getter items : Array(T)

    def each(&block : T -> _)
    end
  end
end
