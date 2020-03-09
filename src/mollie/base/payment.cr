struct Mollie
  struct Base
    abstract struct Payment < Mollie::Base::Resource
      include Mixins::Linkable

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

      {% for value in Status.constants %}
        {% downcased = value.stringify.downcase %}
        def {{ downcased.id }}?
          {{ downcased }} == status
        end
      {% end %}

      json_field(:amount, Amount)
      json_field(:amount_captured, Amount?)
      json_field(:amount_refunded, Amount?)
      json_field(:amount_remaining, Amount?)
      json_field(:application_fee, Payment::ApplicationFee?)
      json_field(:authorized_at, Time?)
      json_field(:canceled_at, Time?)
      json_field(:country_code, String?)
      json_field(:created_at, Time)
      json_field(:customer_id, String?)
      json_field(:description, String)
      json_field(:expired_at, Time?)
      json_field(:expires_at, Time?)
      json_field(:failed_at, Time?)
      json_field(:id, String)
      json_field(:is_cancelable, Bool?)
      json_field(:locale, String)
      json_field(:mandate_id, String?)
      json_field(:metadata, HSBFIS)
      json_field(:method, String?)
      json_field(:mode, String)
      json_field(:order_id, String?)
      json_field(:paid_at, Time?)
      json_field(:profile_id, String)
      json_field(:redirect_url, String)
      json_field(:restrict_payment_methods_to_country, String?)
      json_field(:sequence_type, String?)
      json_field(:settlement_amount, Amount?)
      json_field(:settlement_id, String?)
      json_field(:status, String)
      json_field(:subscription_id, String?)
      json_field(:webhook_url, String)
      @[JSON::Field(converter: Mollie::Json::Underscorer)]
      getter details : HSBFIS?

      def refunded?
        if amount_refunded
          amount_refunded.as(Amount).value > 0
        else
          false
        end
      end

      def checkout_url
        link_for("checkout")
      end

      struct ApplicationFee < Mollie::Base::ApplicationFee
      end
    end
  end
end
