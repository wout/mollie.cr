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
      PayPal
      Paysafecard
      Przelewy24
      Sofort
      KlarnaSliceIt
      KlarnaPayLater

      def to_s
        super.downcase
      end
    end
  end
end
