def example_error_response_json
  <<-JSON
    {
      "status": 401,
      "title": "Unauthorized Request",
      "detail": "Missing authentication, or failed to authenticate",
      "field": "test-field",
      "_links": {
        "documentation": {
          "href": "https://www.mollie.com/en/docs/authentication",
          "type": "text/html"
        }
      }
    }
  JSON
end

def example_not_found_response_json
  <<-JSON
    {
      "status": 404,
      "title": "Not Found",
      "detail": "No payment exists with token tr_WDqYK6vllg.",
      "_links": {
        "documentation": {
          "href": "https://docs.mollie.com/guides/handling-errors",
          "type": "text/html"
        }
      }
    }
  JSON
end
