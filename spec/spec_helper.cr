require "spec"
require "webmock"
require "../src/mollie"

def empty_string_hash
  Hash(String, String).new
end
