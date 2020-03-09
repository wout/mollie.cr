struct Mollie
  struct Customer
    struct Mandate < Base::Resource
      include Mixins::Linkable

      enum Status
        Valid
        Invalid
        Pending

        def to_s
          super.downcase
        end

        def ==(value)
          to_s == value
        end
      end

      {% for value in Status.constants %}
        {% downcased = value.stringify.downcase %}
        def {{ downcased.id }}?
          {{ downcased }} == status
        end
      {% end %}

      json_field(:created_at, Time)
      json_field(:id, String)
      json_field(:mandate_reference, String?)
      json_field(:method, String)
      json_field(:mode, String)
      json_field(:signature_date, String)
      json_field(:status, String)
      @[JSON::Field(converter: Mollie::Json::Underscorer)]
      getter details : HSBFIS?

      def customer(options : Hash | NamedTuple = HS2.new)
        Customer.get(id_from_link("customer"), options)
      end
    end
  end
end
