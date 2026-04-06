module Mollie
  struct Balance
    struct Transaction < Base::Resource
      include Mixins::Linkable

      json_field(:context, HSBFIS?)
      json_field(:created_at, Time)
      json_field(:deductions, Amount?)
      json_field(:id, String)
      json_field(:initial_amount, Amount?)
      json_field(:result_amount, Amount?)
      json_field(:type, String)
    end
  end
end
