struct Mollie
  struct Method < Base
    include Mollie::Mixins::Linkable

    enum Type
      ApplePay
      Bancontact
      BankTransfer
      Belfius
      Creditcard
      DirectDebit
      Eps
      Giftcard
      Giropay
      Ideal
      IngHomePay
      Kbc
      KlarnaPayLater
      KlarnaSliceIt
      PayPal
      Paysafecard
      Przelewy24
      Sofort

      def to_s
        super.downcase
      end
    end

    getter id : String
    getter description : String
    @[JSON::Field(key: "minimumAmount")]
    getter minimum_amount : Mollie::Amount
    @[JSON::Field(key: "maximumAmount")]
    getter maximum_amount : Mollie::Amount
    getter image : Hash(String, String)
    getter pricing : Array(Mollie::Method::Fee)?

    def normal_image
      image["size1x"]
    end

    def bigger_image
      image["size2x"]
    end

    def vector_image
      image["svg"]
    end

    struct Fee
      include JSON::Serializable

      getter description : String
      getter fixed : Mollie::Amount
      @[JSON::Field(nilable: false, converter: Mollie::Json::Decimalizer)]
      getter variable : BigDecimal
      @[JSON::Field(key: "feeRegion")]
      getter region : String
    end
  end
end
