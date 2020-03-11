require "../spec_helper.cr"

alias AI = Array(Mollie::Settlement::Item)

def test_settlement
  Mollie::Settlement.from_json(read_fixture("settlements/get.json"))
end

describe Mollie::Settlement do
  before_each do
    configure_test_api_key
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      test_settlement.open?.should be_false
      test_settlement.pending?.should be_false
      test_settlement.paidout?.should be_true
      test_settlement.failed?.should be_false
    end
  end

  describe "#links" do
    it "contain links" do
      test_settlement.links.should be_a(Mollie::Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      test_settlement.id.should eq("stl_jDk30akdN")
      test_settlement.reference.should eq("1234567.1511.03")
      test_settlement.settled_at.should eq(Time.parse_iso8601("2015-11-06T06:00:02.0Z"))
      test_settlement.created_at.should eq(Time.parse_iso8601("2014-11-06T06:00:02.0Z"))
      test_settlement.amount.should be_a(Mollie::Amount)
      test_settlement.periods.should be_a(Hash(String, Hash(String, Hash(String, AI))))
      revenue = test_settlement.periods.dig("2015", "11", "revenue")
      revenue.should be_a(AI)
      item = revenue.first
      item.should be_a(Mollie::Settlement::Item)
      item.description.should eq("iDEAL")
      item.method.should eq("ideal")
      item.count.should eq(6)
      item.amount_net.should be_a(Mollie::Amount)
      item.amount_vat.should be_a(Mollie::Amount?)
      item.amount_gross.should be_a(Mollie::Amount)
      costs = test_settlement.periods.dig("2015", "11", "costs")
      costs.should be_a(AI)
      costs.first.should be_a(Mollie::Settlement::Item)
      item = costs.first
      item.description.should eq("iDEAL")
      item.method.should eq("ideal")
      item.count.should eq(6)
      item.amount_net.should be_a(Mollie::Amount)
      item.amount_vat.should be_a(Mollie::Amount?)
      item.amount_gross.should be_a(Mollie::Amount)
      rate = item.rate.as(Mollie::Settlement::Item::Rate)
      rate.fixed.should be_a(Mollie::Amount?)
      rate.percentage.should be_a(Mollie::Amount?)
      rate.variable.should be_a(String?)
    end
  end

  describe ".open" do
    it "fetches the open settlement" do
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/open")
        .to_return(status: 200, body: read_fixture("settlements/get.json"))

      settlement = Mollie::Settlement.open
      settlement.should be_a(Mollie::Settlement)
      settlement.id.should eq("stl_jDk30akdN")
    end
  end

  describe ".next" do
    it "fetches the next settlement" do
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/next")
        .to_return(status: 200, body: read_fixture("settlements/get.json"))

      settlement = Mollie::Settlement.next
      settlement.should be_a(Mollie::Settlement)
      settlement.id.should eq("stl_jDk30akdN")
    end
  end

  describe "#payments" do
    it "fetches all related payments" do
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/stl_jDk30akdN/payments")
        .to_return(status: 200, body: read_fixture("settlements/get-payments.json"))

      payments = test_settlement.payments
      payments.should be_a(Mollie::List(Mollie::Settlement::Payment))
      payments.size.should eq(1)
      payments.first.id.should eq("tr_WDqYK6vllg")
    end
  end

  describe "#refunds" do
    it "fetches all related payments" do
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/stl_jDk30akdN/refunds")
        .to_return(status: 200, body: read_fixture("settlements/get-refunds.json"))

      refunds = test_settlement.refunds
      refunds.should be_a(Mollie::List(Mollie::Settlement::Refund))
      refunds.size.should eq(1)
      refunds.first.id.should eq("re_4qqhO89gsT")
    end
  end
end
