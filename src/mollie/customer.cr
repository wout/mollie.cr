struct Mollie
  struct Customer < Base::Resource
    include Mixins::Linkable

    json_field(:id, String)
    json_field(:mode, String)
    json_field(:name, String)
    json_field(:email, String)
    json_field(:locale, String)
    json_field(:metadata, HSBFIS?)
    json_field(:created_at, Time)

    def mandates(options : Hash | NamedTuple = HS2.new)
      Mandate.all(options.to_h.merge({:customer_id => id}))
    end
  end
end
