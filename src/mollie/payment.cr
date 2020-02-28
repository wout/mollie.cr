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
    getter mode : String
    getter description : String
    @[JSON::Field(key: "createdAt", converter: Mollie::Json::TimeFormatter)]
    getter created_at : Time
    getter status : String
    @[JSON::Field(key: "authorizedAt", converter: Mollie::Json::TimeFormatter)]
    getter authorized_at : Time
    @[JSON::Field(key: "paidAt", converter: Mollie::Json::TimeFormatter)]
    getter paid_at : Time
    getter amount : Mollie::Amount
    getter method : String
    @[JSON::Field(key: "countryCode")]
    getter country_code : String
    getter metadata : HSBFIS
    @[JSON::Field(converter: Mollie::Json::Underscorer)]
    getter details : HSBFIS
    getter locale : String
    @[JSON::Field(key: "profileId")]
    getter profile_id : String
    @[JSON::Field(key: "webhookUrl")]
    getter webhook_url : String
    @[JSON::Field(key: "redirectUrl")]
    getter redirect_url : String

    {% for value in Status.constants %}
      {% downcased = value.stringify.downcase %}
      def {{ downcased.id }}?
        {{ downcased }} == status
      end
    {% end %}

    def checkout_url
      Util.extract_url(links, "checkout")
    end
  end
end
