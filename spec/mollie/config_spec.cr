require "../spec_helper.cr"

describe Mollie do
  describe ".configure" do
    it "changes global the confguration" do
      Mollie.configure do |config|
        config.api_key = "my_key"
        config.open_timeout = 1.5.seconds
        config.read_timeout = 2.5.seconds
      end

      Mollie.config.api_key.should eq("my_key")
      Mollie.config.open_timeout.should eq(1.5.seconds)
      Mollie.config.read_timeout.should eq(2.5.seconds)
    end
  end
end

describe Mollie::Config do
  describe "#api_key" do
    it "has no default api key" do
      Mollie.config.api_key.should be_nil
    end
  end

  describe "#open_timeout" do
    it "has a default open timeout" do
      Mollie.config.open_timeout.should eq(60.seconds)
    end
  end

  describe "#read_timeout" do
    it "has a default read timeout" do
      Mollie.config.read_timeout.should eq(60.seconds)
    end
  end

  describe "#decimals" do
    it "contains decimal points for diverging currencies" do
      Mollie.config.currency_decimals.should eq({
        "ISK" => 0,
        "JPY" => 0,
      })
    end
  end
end
