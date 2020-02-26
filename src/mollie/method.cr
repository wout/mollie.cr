struct Mollie
  struct Method < Base
    include JSON::Serializable

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

    getter id : String?
    getter description : String?
    getter minimum_amount : Mollie::Amount
    getter maximum_amount : Mollie::Amount
    getter image : Hash(String, String)

    def normal_image
      image["size1x"]
    end

    def bigger_image
      image["size2x"]
    end

    def vector_image
      image["svg"]
    end
  end
end
