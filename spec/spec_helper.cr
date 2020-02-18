require "spec"
require "webmock"
require "../src/mollie"

def empty_string_hash
  Hash(String, String).new
end

def example_error_response
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

Spec.after_each do
  Mollie::Config.api_key = nil
  Mollie::Config.open_timeout = 60
  Mollie::Config.read_timeout = 60
end
