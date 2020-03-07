struct Mollie
  struct Chargeback < Base::Resource
    include Mixins::Linkable

    json_field(:amount, Amount)
    json_field(:created_at, Time)
    json_field(:id, String)
    json_field(:payment_id, String)
    json_field(:reversed_at, Time?)
    json_field(:settlement_amount, Amount)

    def reversed?
      !!reversed_at
    end

    def payment(options : Hash | NamedTuple = HS2.new)
      Payment.get(payment_id, options)
    end

    def settlement(options : Hash | NamedTuple = HS2.new)
      if links
        if settlement_id = Util.extract_id(links.as(HSHS2), "settlement")
          Settlement.get(settlement_id, options)
        end
      end
    end
  end
end
