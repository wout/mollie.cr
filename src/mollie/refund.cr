struct Mollie
  struct Refund < Base
    include Mollie::Mixins::Linkable

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

    json_field(:amount, Mollie::Amount)
    json_field(:created_at, Time)
    json_field(:description, String)
    json_field(:id, String)
    json_field(:metadata, HSBFIS)
    json_field(:order_id, String)
    json_field(:payment_id, String)
    json_field(:settlement_amount, Mollie::Amount)
    json_field(:status, String)
  end
end
