module Mollie
  struct Permission < Base::Resource
    include Mixins::Linkable

    AVAILABLE = %w[
      customers.read
      customers.write
      invoices.read
      mandates.read
      mandates.write
      organizations.read
      organizations.write
      payments.read
      payments.write
      profiles.read
      profiles.write
      refunds.read
      refunds.write
      settlements.read
      subscriptions.read
      subscriptions.write
    ]

    json_field(:description, String)
    json_field(:granted, Bool)
    json_field(:id, String)
  end
end
