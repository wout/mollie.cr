module Mollie
  struct Balance < Base::Resource
    include Mixins::Linkable

    json_field(:available_amount, Amount?)
    json_field(:created_at, Time)
    json_field(:currency, String)
    json_field(:description, String?)
    json_field(:id, String)
    json_field(:mode, String)
    json_field(:pending_amount, Amount?)
    json_field(:status, String)
    json_field(:transfer_destination, HSBFIS?)
    json_field(:transfer_frequency, String?)
    json_field(:transfer_reference, String?)
    json_field(:transfer_threshold, Amount?)

    def self.primary(options : Hash | NamedTuple = HS2.new)
      get("primary", options)
    end

    def report(options : Hash | NamedTuple = HS2.new)
      response = Client.instance.perform_http_call(
        http_method: "GET",
        api_method: "balances/#{id}/report",
        query: options)
      Balance::Report.from_json(response)
    end

    def transactions(options : Hash | NamedTuple = HS2.new)
      Balance::Transaction.all(options.to_h.merge({:balance_id => id}))
    end
  end
end
