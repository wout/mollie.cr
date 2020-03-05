struct Mollie
  struct Orderline
    include Mollie::Json::Serializable

    json_field(:created_at, Time)
    json_field(:discount_amount, Mollie::Amount)
    json_field(:id, String)
    json_field(:image_url, String)
    json_field(:name, String)
    json_field(:order_id, String)
    json_field(:product_url, String)
    json_field(:quantity, Int32)
    json_field(:sku, String)
    json_field(:status, String)
    json_field(:total_amount, Mollie::Amount)
    json_field(:type, String)
    json_field(:unit_price, Mollie::Amount)
    json_field(:vat_amount, Mollie::Amount)
    json_field(:vat_rate, String)
  end
end
