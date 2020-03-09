require "../spec_helper.cr"

alias AI = Array(Mollie::Settlement::Item)

describe Mollie::Settlement do
  describe "Status enum" do
    describe "#to_s" do
      it "converts to lower case" do
        Mollie::Settlement::Status::Open.to_s.should eq("open")
      end
    end

    describe "#==" do
      it "tests against a lower case string" do
        (Mollie::Settlement::Status::Paidout == "paidout").should be_true
      end
    end
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      settlement = Mollie::Settlement.from_json(read_fixture("settlements/get.json"))
      settlement.open?.should be_false
      settlement.pending?.should be_false
      settlement.paidout?.should be_true
      settlement.failed?.should be_false
    end
  end

  describe "#links" do
    it "contain links" do
      settlement = Mollie::Settlement.from_json(read_fixture("settlements/get.json"))
      settlement.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      settlement = Mollie::Settlement.from_json(read_fixture("settlements/get.json"))
      settlement.id.should eq("stl_jDk30akdN")
      settlement.reference.should eq("1234567.1511.03")
      settlement.settled_at.should eq(Time.parse_rfc3339("2015-11-06T06:00:02.0Z"))
      settlement.created_at.should eq(Time.parse_rfc3339("2014-11-06T06:00:02.0Z"))
      settlement.amount.should be_a(Mollie::Amount)
      settlement.periods.should be_a(Hash(String, Hash(String, Hash(String, AI))))
      revenue = settlement.periods.dig("2015", "11", "revenue")
      revenue.should be_a(AI)
      item = revenue.first
      item.should be_a(Mollie::Settlement::Item)
      item.description.should eq("iDEAL")
      item.method.should eq("ideal")
      item.count.should eq(6)
      item.amount_net.should be_a(Mollie::Amount)
      item.amount_vat.should be_a(Mollie::Amount?)
      item.amount_gross.should be_a(Mollie::Amount)
      costs = settlement.periods.dig("2015", "11", "costs")
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
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/open")
        .to_return(status: 200, body: read_fixture("settlements/get.json"))

      settlement = Mollie::Settlement.open
      settlement.should be_a(Mollie::Settlement)
      settlement.id.should eq("stl_jDk30akdN")
    end
  end

  describe ".next" do
    it "fetches the next settlement" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/next")
        .to_return(status: 200, body: read_fixture("settlements/get.json"))

      settlement = Mollie::Settlement.next
      settlement.should be_a(Mollie::Settlement)
      settlement.id.should eq("stl_jDk30akdN")
    end
  end

  describe "#payments" do
    it "fetches all related payments" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/stl_jDk30akdN/payments")
        .to_return(status: 200, body: read_fixture("settlements/get-payments.json"))

      settlement = Mollie::Settlement.from_json(read_fixture("settlements/get.json"))
      payments = settlement.payments
      payments.should be_a(Mollie::List(Mollie::Settlement::Payment))
      payments.size.should eq(1)
      payments.first.id.should eq("tr_WDqYK6vllg")
    end
  end

  describe "#refunds" do
    it "fetches all related payments" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/settlements/stl_jDk30akdN/refunds")
        .to_return(status: 200, body: read_fixture("settlements/get-refunds.json"))

      settlement = Mollie::Settlement.from_json(read_fixture("settlements/get.json"))
      refunds = settlement.refunds
      refunds.should be_a(Mollie::List(Mollie::Settlement::Refund))
      refunds.size.should eq(1)
      refunds.first.id.should eq("re_4qqhO89gsT")
    end
  end
end
