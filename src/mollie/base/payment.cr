struct Mollie
  struct Base
    abstract struct Payment < Resource
      include Mixins::Linkable

      enum Status
        Open
        Canceled
        Pending
        Expired
        Failed
        Paid
        Authorized
      end

      status_enum_methods

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
      json_field(:locale, String?)
      json_field(:mandate_id, String?)
      json_field(:metadata, HSBFIS?)
      json_field(:method, String?)
      json_field(:mode, String)
      json_field(:order_id, String?)
      json_field(:paid_at, Time?)
      json_field(:profile_id, String)
      json_field(:redirect_url, String?)
      json_field(:restrict_payment_methods_to_country, String?)
      json_field(:sequence_type, String?)
      json_field(:settlement_amount, Amount?)
      json_field(:settlement_id, String?)
      json_field(:status, String)
      json_field(:subscription_id, String?)
      json_field(:webhook_url, String?)
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
        link_for(:checkout)
      end

      def refund!(options : Hash | NamedTuple = HS2.new)
        Mollie::Payment::Refund.create({
          :amount => amount.to_h,
        }.merge(options.to_h).merge({:payment_id => id}))
      end

      {% begin %}
        {% for method in %w[capture chargeback refund] %}
          def {{ "#{method.id}s".id }}(options : Hash | NamedTuple = HS2.new)
            Mollie::Payment::{{ method.camelcase.id }}.all(options.to_h.merge({
              :payment_id => id
            }))
          end
        {% end %}

        {% for method in %w[customer settlement order] %}
          def {{ method.id }}(options : Hash | NamedTuple = HS2.new)
            if {{ method.id }}_id
              {{ method.camelcase.id }}.get({{ method.id }}_id.as(String), options)
            end
          end
        {% end %}

        {% for method in %w[mandate subscription] %}
          def {{ method.id }}(options : Hash | NamedTuple = HS2.new)
            if customer_id && {{ method.id }}_id
              options = options.to_h.merge({:customer_id => customer_id.as(String)})
              Customer::{{ method.camelcase.id }}.get({{ method.id }}_id.as(String), options)
            end
          end
        {% end %}
      {% end %}

      struct ApplicationFee < Mollie::Base::ApplicationFee
      end
    end
  end
end
