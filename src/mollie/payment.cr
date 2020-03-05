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

    json_field(:amount, Mollie::Amount)
    json_field(:amount_captured, Mollie::Amount?)
    json_field(:amount_refunded, Mollie::Amount?)
    json_field(:amount_remaining, Mollie::Amount?)
    json_field(:application_fee, Mollie::Payment::ApplicationFee?)
    json_field(:authorized_at, Time?)
    json_field(:country_code, String?)
    json_field(:created_at, Time)
    json_field(:customer_id, String?)
    json_field(:description, String)
    json_field(:id, String)
    json_field(:locale, String)
    json_field(:metadata, HSBFIS)
    json_field(:method, String?)
    json_field(:mode, String)
    json_field(:paid_at, Time?)
    json_field(:profile_id, String)
    json_field(:redirect_url, String)
    json_field(:restrict_payment_methods_to_country, String?)
    json_field(:status, String)
    json_field(:webhook_url, String)
    @[JSON::Field(converter: Mollie::Json::Underscorer)]
    getter details : HSBFIS?

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
      include Mollie::Json::Serializable

      json_field(:amount, Mollie::Amount)
      json_field(:description, String)
    end
  end
end
