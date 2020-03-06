struct Mollie
  struct Settlement < Base::Resource
    include Mixins::Linkable

    enum Status
      Open
      Pending
      Paidout
      Failed

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

    json_field(:amount, Amount)
    json_field(:id, String)
    json_field(:periods, Hash(String, Hash(String, Hash(String, Array(Item)))))
    json_field(:reference, String)
    json_field(:settled_at, Time)
    json_field(:status, String)

    struct Item
      include Json::Serializable

      json_field(:description, String)
      json_field(:method, String)
      json_field(:count, Int32)
      json_field(:amount_net, Amount)
      json_field(:amount_vat, Amount?)
      json_field(:amount_gross, Amount)
      json_field(:rate, Rate?)

      struct Rate
        include Json::Serializable

        json_field(:fixed, Amount?)
        json_field(:percentage, Amount?)
        json_field(:variable, String?)
      end
    end
  end
end
