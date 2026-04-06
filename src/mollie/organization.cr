module Mollie
  struct Organization < Base::Resource
    include Mixins::Linkable

    json_field(:id, String)
    json_field(:name, String)
    json_field(:locale, String?)
    json_field(:email, String)
    json_field(:address, Address)
    json_field(:registration_number, String)
    json_field(:vat_number, String)
    json_field(:vat_regulation, String?)

    def self.current(options : Hash | NamedTuple = HS2.new)
      get("me", options)
    end

    def dashboard_url
      link_for(:dashboard)
    end

    struct Address
      include Json::Serializable

      json_field(:street_and_number, String)
      json_field(:postal_code, String)
      json_field(:city, String)
      json_field(:country, String)
    end
  end
end
