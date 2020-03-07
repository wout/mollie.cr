struct Mollie
  struct Order < Base::Resource
    include Mixins::Linkable

    enum Status
      Authorized
      Canceled
      Completed
      Created
      Expired
      Paid
      Pending
      Shipping

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

    json_field(:id, String)
    json_field(:profile_id, String)
    json_field(:method, String)
    json_field(:amount, Amount)
    json_field(:status, String)
    json_field(:is_cancelable, Bool?)
    json_field(:metadata, HSBFIS?)
    json_field(:created_at, Time)
    json_field(:expires_at, Time)
    json_field(:mode, String)
    json_field(:locale, String)
    json_field(:billing_address, Address)
    json_field(:shopper_country_must_match_billing_country, Bool)
    json_field(:consumer_date_of_birth, String)
    json_field(:order_number, String)
    json_field(:shipping_address, Address)
    json_field(:redirect_url, String)
    json_field(:lines, Array(Orderline))

    def checkout_url
      Util.extract_url(links, "checkout")
    end

    def refunds(options : Hash | NamedTuple = HS2.new)
      Order::Refund.all(options.to_h.merge({:order_id => id}))
    end

    struct Address
      include Json::Serializable

      json_field(:organization_name, String)
      json_field(:street_and_number, String)
      json_field(:postal_code, String)
      json_field(:city, String)
      json_field(:country, String)
      json_field(:given_name, String)
      json_field(:family_name, String)
      json_field(:email, String)
    end
  end
end
