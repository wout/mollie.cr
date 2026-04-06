module Mollie
  struct Sandbox
    getter client : Client

    def initialize(@client : Client)
    end

    {% begin %}
      {% resources = %w[
           balance
           chargeback
           customer
           customer_mandate
           customer_payment
           customer_subscription
           invoice
           method
           onboarding
           order
           order_line
           order_payment
           order_refund
           order_shipment
           organization
           partner
           payment
           payment_capture
           payment_chargeback
           payment_link
           payment_refund
           permission
           profile
           refund
           settlement
           settlement_capture
           settlement_chargeback
           settlement_payment
           settlement_refund
           subscription
           terminal
         ] %}

      {% for resource in resources %}
        {% resource_class = resource.split('_').map(&.camelcase).join("::") %}

        struct {{ resource_class.id }}
          getter client : Client

          def initialize(@client : Client)
          end

          {% for method in %w[all get create update delete cancel] %}
            def {{ method.id }}(*args)
              Mollie::{{ resource_class.id }}.{{ method.id }}(*args, client: @client)
            end
          {% end %}
        end

        def {{ resource.id }}
          Mollie::Sandbox::{{ resource_class.id }}.new(@client)
        end
      {% end %}
    {% end %}
  end
end
