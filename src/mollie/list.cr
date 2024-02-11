module Mollie
  struct List(T) < Base::Resource
    include Mixins::Linkable

    macro list_root
      name = {{ T.id }}.name.split("::").last.downcase
      Wordsmith::Inflector.pluralize(name)
    end

    {% begin %}
      {% for name in %w[previous next] %}
        def {{name.id}}(options : Hash | NamedTuple = HS2.new)
          return self unless href = link_for?({{ name }})

          query = Util.query_from_href(href)
          T.all(options: options.to_h.merge(query))
        end
      {% end %}
    {% end %}

    forward_missing_to @items

    @[JSON::Field(key: "_embedded", root: list_root)]
    getter items : Array(T)
  end
end
