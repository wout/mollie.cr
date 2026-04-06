require "../spec_helper.cr"

def test_balance
  Mollie::Balance.from_json(read_fixture("balances/get.json"))
end

describe Mollie::Balance do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "is linkable" do
      test_balance.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_balance.id.should eq("bal_gVMhHKqSSRYJyPsuoPNFH")
      test_balance.mode.should eq("live")
      test_balance.currency.should eq("EUR")
      test_balance.description.should eq("Primary balance")
      test_balance.status.should eq("active")
      test_balance.transfer_frequency.should eq("twice-a-month")
      test_balance.transfer_reference.should eq("Mollie payout")
      test_balance.transfer_threshold.should be_a(Mollie::Amount?)
      test_balance.transfer_threshold.as(Mollie::Amount).value.should eq(5.0.to_big_d)
      test_balance.available_amount.should be_a(Mollie::Amount?)
      test_balance.available_amount.as(Mollie::Amount).value.should eq(905.25.to_big_d)
      test_balance.pending_amount.should be_a(Mollie::Amount?)
      test_balance.created_at.should eq(Time.parse_iso8601("2019-01-10T12:06:28+00:00"))
    end
  end
end
