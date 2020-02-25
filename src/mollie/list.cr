struct Mollie
  struct List(T) < Base
    macro list_root
      name = {{ T.id }}.name.split("::").last.downcase
      Wordsmith::Inflector.pluralize(name)
    end

    @[JSON::Field(key: "_embedded", root: list_root)]
    getter items : Array(T)

    @[JSON::Field(key: "_links")]
    getter links : Hash(String, Hash(String, String))?

    forward_missing_to @items
  end
end
