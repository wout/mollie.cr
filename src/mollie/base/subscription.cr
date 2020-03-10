struct Mollie
  struct Base
    abstract struct Subscription < Resource
      include Mixins::Linkable

      enum Status
        Active
        Pending # Waiting for a valid mandate.
        Canceled
        Suspended # Active, but mandate became invalid.
        Completed

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
      json_field(:application_fee, ApplicationFee?)
      json_field(:canceled_at, Time?)
      json_field(:created_at, Time)
      json_field(:customer_id, String?)
      json_field(:description, String)
      json_field(:id, String)
      json_field(:interval, String)
      json_field(:mandate_id, String?)
      json_field(:metadata, HSBFIS?)
      json_field(:method, String?)
      json_field(:mode, String)
      json_field(:next_payment_date, String?)
      json_field(:start_date, String)
      json_field(:status, String)
      json_field(:times, Int32)
      json_field(:times_remaining, Int32)
      json_field(:webhook_url, String)

      def customer(options : Hash | NamedTuple = HS2.new)
        Customer.get(customer_id.as(String), options) if customer_id
      end

      def payments(options : Hash | NamedTuple = HS2.new)
        if resource_url = link_for?(:payments)
          response = Mollie::Client.instance.perform_http_call(
            http_method: "GET",
            api_method: resource_url,
            query: options)
          List(Mollie::Customer::Payment).from_json(response)
        end
      end

      struct ApplicationFee < Mollie::Base::ApplicationFee
      end
    end
  end
end
