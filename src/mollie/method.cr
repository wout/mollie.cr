struct Mollie
  class Method < Base
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
  end
end
