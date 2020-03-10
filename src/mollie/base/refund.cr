struct Mollie
  struct Base
    abstract struct Refund < Resource
      include Mixins::Linkable

      enum Status
        Queued
        Pending
        Processing
        Refunded
        Failed
      end

      status_enum_methods

      json_field(:amount, Amount)
      json_field(:created_at, Time)
      json_field(:description, String)
      json_field(:id, String)
      json_field(:lines, Array(Mollie::Line))
      json_field(:metadata, HSBFIS?)
      json_field(:order_id, String)
      json_field(:payment_id, String)
      json_field(:settlement_id, String?)
      json_field(:settlement_amount, Amount?)
      json_field(:status, String)

      def payment(options : Hash | NamedTuple = HS2.new)
        Mollie::Payment.get(payment_id, options)
      end

      def settlement(options : Hash | NamedTuple = HS2.new)
        if settlement_id
          Mollie::Settlement.get(settlement_id.as(String), options)
        end
      end
    end
  end
end
