struct Mollie
  struct Base
    abstract struct Capture < Resource
      include Mixins::Linkable

      json_field(:amount, Amount)
      json_field(:created_at, Time)
      json_field(:id, String)
      json_field(:mode, String)
      json_field(:payment_id, String)
      json_field(:settlement_amount, Amount?)
      json_field(:settlement_id, String?)
      json_field(:shipment_id, String?)

      def payment(options : Hash | NamedTuple = HS2.new)
        Mollie::Payment.get(payment_id, options)
      end

      def shipment(options : Hash | NamedTuple = HS2.new)
        if resource_url = link_for?(:shipment)
          response = Client.instance.perform_http_call(
            http_method: "GET",
            api_method: resource_url,
            query: options)
          Order::Shipment.from_json(response)
        end
      end

      def settlement(options : Hash | NamedTuple = HS2.new)
        Settlement.get(settlement_id.as(String), options) if settlement_id
      end
    end
  end
end
