module Mollie
  struct Balance
    struct Report < Base::Resource
      include Mixins::Linkable

      json_field(:balance_id, String)
      json_field(:from, String?)
      json_field(:grouping, String)
      json_field(:time_zone, String)
      json_field(:totals, HSBFIS?)
      @[JSON::Field(key: "until")]
      getter until_date : String?
    end
  end
end
