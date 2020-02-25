struct Mollie
  abstract struct List(T) < Base
    include Enumerable(T)

    @[JSON::Field(key: "_embedded", converter: Mollie::Json::ListConverter)]
    getter items : Array(T)?

    def each(&block : T -> _)
    end
  end
end
