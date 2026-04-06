module Mollie
  struct Method < Base::Resource
    include Mixins::Linkable

    enum Type
      Alma
      ApplePay
      Bancolombia
      BancomatPay
      Bancontact
      BankTransfer
      Belfius
      Billie
      Blik
      Creditcard
      DirectDebit
      Eps
      Giftcard
      Giropay
      Ideal
      IngHomePay
      In3
      Kbc
      Klarna
      KlarnaPayLater
      KlarnaSliceIt
      MyBank
      Payconiq
      PayPal
      Paysafecard
      Przelewy24
      Riverty
      Satispay
      Sofort
      Trustly
      Twint

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
    json_field(:issuers, Array(Issuer)?)
    json_field(:maximum_amount, Amount)
    json_field(:minimum_amount, Amount)
    json_field(:pricing, Array(Method::Fee)?)
    json_field(:status, String?)

    def normal_image
      image["size1x"]
    end

    def bigger_image
      image["size2x"]
    end

    def vector_image
      image["svg"]
    end

    def self.all_available(options : Hash | NamedTuple = HS2.new)
      all(options.to_h.merge({"include" => "issuers,pricing"}))
    end

    struct Fee
      include Json::Serializable

      json_field(:description, String)
      json_field(:fee_region, String?)
      json_field(:fixed, Amount)
      json_field(:variable, BigDecimal)
    end

    struct Issuer
      include Json::Serializable

      json_field(:id, String)
      json_field(:name, String)
      json_field(:image, HS2)
    end
  end
end
