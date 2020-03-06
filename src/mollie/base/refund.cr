struct Mollie
  struct Base
    abstract struct Refund < Mollie::Base::Resource
      include Mixins::Linkable

      enum Status
        Queued
        Pending
        Processing
        Refunded
        Failed

        def to_s
          super.downcase
        end

        def ==(value)
          to_s == value
        end
      end

      json_field(:amount, Amount)
      json_field(:created_at, Time)
      json_field(:description, String)
      json_field(:id, String)
      json_field(:lines, Array(Orderline))
      json_field(:metadata, HSBFIS)
      json_field(:order_id, String)
      json_field(:payment_id, String)
      json_field(:settlement_amount, Amount)
      json_field(:status, String)

      def payment(options : Hash | NamedTuple = HS2.new)
        Mollie::Payment.get(payment_id, options)
      end
    end
  end
end
