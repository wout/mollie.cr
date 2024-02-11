module Mollie
  struct Onboarding < Base::Resource
    include Mixins::Linkable

    json_field(:can_receive_payments, Bool)
    json_field(:can_receive_settlements, Bool)
    json_field(:name, String)
    json_field(:signed_up_at, Time)
    json_field(:status, String)

    def dashboard
      link_for(:dashboard)
    end

    def organization(options : Hash | NamedTuple = HS2.new)
      response = Client.instance.perform_http_call(
        http_method: "GET",
        api_method: link_for(:organization),
        query: options)
      Organization.from_json(response)
    end

    def self.me(options : Hash | NamedTuple = HS2.new)
      response = Client.instance.perform_http_call(
        http_method: "GET",
        api_method: "onboarding",
        id: "me",
        query: options)
      from_json(response)
    end

    def self.submit(
      data : Hash | NamedTuple = HS2.new,
      options : Hash | NamedTuple = HS2.new
    )
      Client.instance.perform_http_call(
        http_method: "POST",
        api_method: "onboarding",
        id: "me",
        http_body: data,
        query: options)
    end
  end
end
