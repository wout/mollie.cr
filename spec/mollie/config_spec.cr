require "../spec_helper.cr"

describe "Mollie::Config" do
  describe ".api_key" do
    it "has no default api key" do
      Mollie::Config.api_key.should be_nil
    end
  end

  describe ".open_timeout" do
    it "has a default open timeout" do
      Mollie::Config.open_timeout.should eq(60)
    end
  end

  describe ".read_timeout" do
    it "has a default read timeout" do
      Mollie::Config.read_timeout.should eq(60)
    end
  end
end
