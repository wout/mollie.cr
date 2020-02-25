def mastaba_list_json
  %({
    "_embedded": { "mastabas": [
      { "id": "tr_1" },
      { "id": "tr_2" }
    ] },
    "count": 2,
    "_links": {
      "self": {
        "href": "https://api.mollie.com/v2/payments?limit=5",
        "type": "application/hal+json"
      },
      "previous": {
        "href": "https://api.mollie.com/v2/payments?from=tr_1&limit=1",
        "type": "application/hal+json"
      },
      "next": {
        "href": "https://api.mollie.com/v2/payments?from=tr_2&limit=1",
        "type": "application/hal+json"
      },
      "documentation": {
        "href": "https://docs.mollie.com/reference/payments/list",
        "type": "text/html"
      }
    }
  })
end
