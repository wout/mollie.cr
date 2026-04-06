module Mollie
  struct Terminal < Base::Resource
    include Mixins::Linkable

    enum Status
      Pending
      Active
      Inactive
    end

    status_enum_methods

    json_field(:brand, String?)
    json_field(:created_at, Time)
    json_field(:currency, String?)
    json_field(:deactivated_at, Time?)
    json_field(:description, String?)
    json_field(:id, String)
    json_field(:model, String?)
    json_field(:profile_id, String)
    json_field(:serial_number, String?)
    json_field(:status, String)
    json_field(:updated_at, Time?)
  end
end
