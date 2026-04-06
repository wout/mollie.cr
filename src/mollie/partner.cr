module Mollie
  struct Partner < Base::Resource
    include Mixins::Linkable

    json_field(:is_commission_partner, Bool?)
    json_field(:partner_contract_signed_at, Time?)
    json_field(:partner_contract_update_available, Bool?)
    json_field(:partner_type, String?)
    json_field(:user_agent_tokens, Array(HSBFIS)?)

    def self.current(options : Hash | NamedTuple = HS2.new)
      response = Client.instance.perform_http_call(
        http_method: "GET",
        api_method: "organizations/me/partner",
        query: options)
      from_json(response)
    end

    def type
      partner_type
    end

    def commission_partner?
      !!is_commission_partner
    end

    def contract_update_available?
      !!partner_contract_update_available
    end

    def signuplink
      link_for(:signuplink)
    end
  end
end
