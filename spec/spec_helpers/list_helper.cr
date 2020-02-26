def mastaba_list_json
  %({
    "_embedded": { "mastabas": [
      { "id": "tr_1" },
      { "id": "tr_2" }
    ] },
    "count": 2,
    "_links": {
      "self": {
        "href": "https://api.mollie.com/v2/mastabas?limit=5",
        "type": "application/hal+json"
      },
      "previous": {
        "href": "https://api.mollie.com/v2/mastabas?from=tr_1&limit=1",
        "type": "application/hal+json"
      },
      "next": {
        "href": "https://api.mollie.com/v2/mastabas?from=tr_2&limit=1",
        "type": "application/hal+json"
      },
      "documentation": {
        "href": "https://docs.mollie.com/reference/mastabas/list",
        "type": "text/html"
      }
    }
  })
end

def mastaba_next_list_json
  %({
    "_embedded": {
      "mastabas":[
        {"id":"tr_next_1"},
        {"id":"tr_next_2"}
      ]
    },
    "count":2
  })
end

def mastaba_previous_list_json
  %({
    "_embedded": {
      "mastabas":[
        {"id":"tr_previous_1"},
        {"id":"tr_previous_2"}
      ]
    },
    "count":2
  })
end

def mastaba_list_without_pages_json
  %({
    "_embedded": { "mastabas": [] },
    "count": 2,
    "_links": {
      "self": {
        "href": "https://api.mollie.com/v2/mastabas?limit=5",
        "type": "application/hal+json"
      },
      "documentation": {
        "href": "https://docs.mollie.com/reference/mastabas/list",
        "type": "text/html"
      }
    }
  })
end
