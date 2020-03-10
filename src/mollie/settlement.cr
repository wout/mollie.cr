struct Mollie
  struct Settlement < Base::Resource
    include Mixins::Linkable

    enum Status
      Open
      Pending
      Paidout
      Failed
    end

    status_enum_methods

    json_field(:amount, Amount)
    json_field(:created_at, Time)
    json_field(:id, String)
    json_field(:periods, Hash(String, Hash(String, Hash(String, Array(Item)))))
    json_field(:reference, String)
    json_field(:settled_at, Time)
    json_field(:status, String)

    {% begin %}
      {% for status in %w[open next] %}
        def self.{{ status.id }}(options : Hash | NamedTuple = HS2.new)
          get({{ status }}, options)
        end
      {% end %}
    {% end %}

    def payments(options : Hash | NamedTuple = HS2.new)
      Payment.all(options.merge({:settlement_id => id}))
    end

    def refunds(options : Hash | NamedTuple = HS2.new)
      Refund.all(options.merge({:settlement_id => id}))
    end

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
