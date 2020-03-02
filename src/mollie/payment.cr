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

    getter amount : Mollie::Amount
    getter amount_captured : Mollie::Amount?
    getter amount_refunded : Mollie::Amount?
    getter amount_remaining : Mollie::Amount?
    @[JSON::Field(key: "applicationFee")]
    getter application_fee : Mollie::Payment::ApplicationFee?
    @[JSON::Field(key: "authorizedAt", converter: Mollie::Json::TimeFormatter)]
    getter authorized_at : Time?
    @[JSON::Field(key: "countryCode")]
    getter country_code : String?
    @[JSON::Field(key: "createdAt", converter: Mollie::Json::TimeFormatter)]
    getter created_at : Time
    @[JSON::Field(key: "customerId")]
    getter customer_id : String?
    getter description : String
    @[JSON::Field(converter: Mollie::Json::Underscorer)]
    getter details : HSBFIS?
    getter id : String
    getter locale : String
    getter metadata : HSBFIS
    getter method : String?
    getter mode : String
    @[JSON::Field(key: "paidAt", converter: Mollie::Json::TimeFormatter)]
    getter paid_at : Time?
    @[JSON::Field(key: "profileId")]
    getter profile_id : String
    @[JSON::Field(key: "redirectUrl")]
    getter redirect_url : String
    @[JSON::Field(key: "restrictPaymentMethodsToCountry")]
    getter restrict_payment_methods_to_country : String?
    getter status : String
    @[JSON::Field(key: "webhookUrl")]
    getter webhook_url : String

    {% for value in Status.constants %}
      {% downcased = value.stringify.downcase %}
      def {{ downcased.id }}?
        {{ downcased }} == status
      end
    {% end %}

    def refunded?
      if amount_refunded
        amount_refunded.as(Mollie::Amount).value > 0
      else
        false
      end
    end

    def checkout_url
      Util.extract_url(links, "checkout")
    end

    struct ApplicationFee
      include JSON::Serializable

      getter amount : Mollie::Amount
      getter description : String
    end
  end
end
