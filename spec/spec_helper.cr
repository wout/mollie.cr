require "spec"
require "webmock"
require "../src/mollie"

def empty_string_hash
  Hash(String, String).new
end

Spec.after_each do
  Mollie::Config.api_key = nil
  Mollie::Config.open_timeout = 60
  Mollie::Config.read_timeout = 60
end
