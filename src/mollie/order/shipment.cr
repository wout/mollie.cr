struct Mollie
  struct Order
    struct Shipment < Base::Resource
      include Mixins::Linkable

      json_field(:created_at, Time)
      json_field(:id, String)
      json_field(:lines, Array(Orderline))
      json_field(:order_id, String)
      json_field(:tracking, Tracking?)

      def order(options : Hash | NamedTuple = HS2.new)
        Order.get(order_id, options)
      end

      struct Tracking
        include Json::Serializable

        json_field(:carrier, String)
        json_field(:code, String)
        json_field(:url, String)
      end
    end
  end
end
