struct Mollie
  struct Payment < Base
    include Mollie::Mixins::Linkable

    enum Status
      Open
      Canceled
      Pending
      Expired
      Failed
      Paid
      Authorized

      def to_s
        super.downcase
      end

      def ==(value)
        to_s == value
      end
    end

    getter id : String
    getter description : String
    @[JSON::Field(key: "createdAt", converter: Mollie::Json::TimeFormatter)]
    getter created_at : Time
    getter status : String
    @[JSON::Field(key: "authorizedAt", converter: Mollie::Json::TimeFormatter)]
    getter authorized_at : Time
    @[JSON::Field(key: "paidAt", converter: Mollie::Json::TimeFormatter)]
    getter paid_at : Time
    getter amount : Mollie::Amount
    getter description : String
    getter method : String

    {% for value in Status.constants %}
      {% downcased = value.stringify.downcase %}
      def {{ downcased.id }}?
        {{ downcased }} == status
      end
    {% end %}
  end
end
