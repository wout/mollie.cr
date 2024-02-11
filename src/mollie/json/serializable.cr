module Mollie
  struct Json
    module Serializable
      macro included
        include JSON::Serializable
      end

      macro json_field(name, type)
        {% camelized = name.id.stringify.camelcase(lower: true) %}
        {% if [Time.id, "::Union(Time, ::Nil)".id].includes?(type.id) %}
          @[JSON::Field(key: {{ camelized }},
            converter: Mollie::Json::TimeFormatter)]
        {% elsif [BigDecimal.id, "::Union(BigDecimal, ::Nil)".id].includes?(type.id) %}
          @[JSON::Field(key: {{ camelized }},
            nilable: false,
            converter: Mollie::Json::Decimalizer)]
        {% else %}
          @[JSON::Field(key: {{ camelized }})]
        {% end %}
        getter {{ name.id }} : {{ type }}
      end
    end
  end
end
