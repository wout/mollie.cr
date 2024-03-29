module Mollie
  struct Method < Base::Resource
    include Mixins::Linkable

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

      def ==(other)
        to_s == other
      end
    end

    json_field(:description, String)
    json_field(:id, String)
    json_field(:image, HS2)
    json_field(:maximum_amount, Amount)
    json_field(:minimum_amount, Amount)
    json_field(:pricing, Array(Method::Fee)?)

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
      include Json::Serializable

      json_field(:description, String)
      json_field(:fee_region, String?)
      json_field(:fixed, Amount)
      json_field(:variable, BigDecimal)
    end
  end
end
