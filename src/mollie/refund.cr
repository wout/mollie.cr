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
    json_field(:description, String)
    json_field(:id, String)
    json_field(:settlement_amount, Mollie::Amount)
    json_field(:settlement_id, String?)
    json_field(:status, String)
  end
end
