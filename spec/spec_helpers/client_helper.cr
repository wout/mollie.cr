def mollie_api_token
  "test_dHar4XY7LxsDOtmnkVtjNVWXLSlXsM"
end

def create_mollie_client
  Mollie::Client.new(mollie_api_token)
end

def client_http_headers(overrides : Hash(String, String)? = Hash(String, String).new)
  {
    "Accept"        => "application/json",
    "Content-type"  => "application/json",
    "Authorization" => "Bearer #{mollie_api_token}",
    "User-Agent"    => Mollie::Util.version_string,
  }.merge(overrides)
end
