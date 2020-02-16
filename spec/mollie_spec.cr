require "./spec_helper.cr"

describe "Mollie" do
  describe ".configure" do
    it "changes global confguration" do
      Mollie.configure do |config|
        config.api_key = "my_key"
        config.open_timeout = 1.5
        config.read_timeout = 2.5
      end

      Mollie::Config.api_key.should eq("my_key")
      Mollie::Config.open_timeout.should eq(1.5)
      Mollie::Config.read_timeout.should eq(2.5)
    end
  end
end
