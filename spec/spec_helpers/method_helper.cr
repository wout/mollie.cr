def get_method_with_pricing_json
  %({
    "id": "creditcard",
    "description": "Credit card",
    "minimum_amount": { "value": "0.01", "currency": "EUR" },
    "maximum_amount": { "value": "2000.00", "currency": "EUR" },
    "image": {
      "size1x": "https://www.mollie.com/external/icons/payment-methods/creditcard.png",
      "size2x": "https://www.mollie.com/external/icons/payment-methods/creditcard%402x.png",
      "svg": "https://www.mollie.com/external/icons/payment-methods/creditcard.svg"
    }
  })
end
