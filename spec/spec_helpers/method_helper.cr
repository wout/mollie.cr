def get_method_json
  %({
    "id": "creditcard",
    "description": "Credit card",
    "minimumAmount": { "value": "0.01", "currency": "EUR" },
    "maximumAmount": { "value": "2000.00", "currency": "EUR" },
    "image": {
      "size1x": "https://www.mollie.com/external/icons/payment-methods/creditcard.png",
      "size2x": "https://www.mollie.com/external/icons/payment-methods/creditcard%402x.png",
      "svg": "https://www.mollie.com/external/icons/payment-methods/creditcard.svg"
    }
  })
end
