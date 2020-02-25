struct Mollie
  struct Payment < Base
    getter id : String?

    def self.list_from_json
    end
  end

  struct PaymentList < List(Mollie::Payment)
  end
end
