require "./exception_helper.cr"

def create_mollie_client
  Mollie::Client.new(mollie_test_api_key)
end
