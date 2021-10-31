require "spec"
require "webmock"
require "../src/mollie"

def empty_string_hash
  Mollie::HS2.new
end

def mollie_test_api_key
  "test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM"
end

def configure_test_api_key
  Mollie.config.api_key = mollie_test_api_key
end

def client_http_headers(overrides : Mollie::HS2? = Mollie::HS2.new)
  {
    "Accept"        => "application/json",
    "Content-type"  => "application/json",
    "Authorization" => "Bearer #{mollie_test_api_key}",
    "User-Agent"    => Mollie::Util.version_string,
  }.merge(overrides)
end

def read_fixture(file : String)
  path = "#{__DIR__}/fixtures/#{file}"
  if File.exists?(path)
    File.read(path)
  else
    raise Exception.new("Fixture #{file} does not exist.")
  end
end

Spec.after_each do
  WebMock.reset
  Mollie.configure do |config|
    config.api_key = nil
    config.open_timeout = 60
    config.read_timeout = 60
    config.currency_decimals = {
      "ISK" => 0,
      "JPY" => 0,
    }
  end
end
