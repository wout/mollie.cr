struct Mollie
  struct List(T) < Base
    include Mollie::Mixins::Linkable

    alias HS2 = Hash(String, String)
    alias HSHS2 = Hash(String, HS2)

    macro list_root
      name = {{ T.id }}.name.split("::").last.downcase
      Wordsmith::Inflector.pluralize(name)
    end

    macro define_pagination_methods
      {% for name in %w[previous next] %}
        def {{name.id}}(options : Hash | NamedTuple = HS2.new)
          return self unless href = links.as(HSHS2).dig?({{ name }}, "href")

          query = Util.query_from_href(href)
          T.all(options: options.to_h.merge(query))
        end
      {% end %}
    end

    define_pagination_methods
    forward_missing_to @items

    @[JSON::Field(key: "_embedded", root: list_root)]
    getter items : Array(T)
  end
end
