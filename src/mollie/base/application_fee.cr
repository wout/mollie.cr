struct Mollie
  struct Base
    abstract struct ApplicationFee
      include Json::Serializable

      json_field(:amount, Amount)
      json_field(:description, String)
    end
  end
end
