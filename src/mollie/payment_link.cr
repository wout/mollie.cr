module Mollie
  struct PaymentLink < Base::Resource
    include Mixins::Linkable

    json_field(:amount, Amount?)
    json_field(:archived, Bool?)
    json_field(:created_at, Time)
    json_field(:description, String)
    json_field(:expires_at, Time?)
    json_field(:id, String)
    json_field(:mode, String)
    json_field(:paid_at, Time?)
    json_field(:profile_id, String)
    json_field(:redirect_url, String?)
    json_field(:updated_at, Time?)
    json_field(:webhook_url, String?)

    def archived?
      !!archived
    end

    def payment_link
      link_for(:payment_link)
    end

    def payments(options : Hash | NamedTuple = HS2.new)
      Payment.all(options.to_h.merge({:payment_link_id => id}))
    end

    def self.resource_name(parent_id : String? = nil)
      "payment-links"
    end
  end
end
