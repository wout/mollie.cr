module Mollie
  struct Payment
    struct Line
      include Json::Serializable

      json_field(:categories, Array(String)?)
      json_field(:description, String?)
      json_field(:discount_amount, Amount?)
      json_field(:image_url, String?)
      json_field(:product_url, String?)
      json_field(:quantity, Int32?)
      json_field(:quantity_unit, String?)
      json_field(:sku, String?)
      json_field(:total_amount, Amount?)
      json_field(:type, String?)
      json_field(:unit_price, Amount?)
      json_field(:vat_amount, Amount?)
      json_field(:vat_rate, String?)

      def discounted?
        !!discount_amount
      end
    end
  end
end
