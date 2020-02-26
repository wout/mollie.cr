require "../spec_helper.cr"

describe Mollie::State do
  describe ".instances" do
    it "only accepts client instances" do
      Mollie::State.instances.should be_a(Hash(String, Mollie::Client))
    end
  end
end
