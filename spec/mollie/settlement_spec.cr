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

  describe "#links" do
    it "contain links" do
      settlement = Mollie::Settlement.from_json(read_fixture("settlements/get.json"))
      links = settlement.links.as(HSHS2)
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      settlement = Mollie::Settlement.from_json(read_fixture("settlements/get.json"))
      settlement.id.should eq("stl_jDk30akdN")
      settlement.reference.should eq("1234567.1511.03")
      settlement.settled_at.should eq(Time.parse_rfc3339("2015-11-06T06:00:02.0Z"))
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

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      settlement = Mollie::Settlement.from_json(read_fixture("settlements/get.json"))
      settlement.open?.should be_false
      settlement.pending?.should be_false
      settlement.paidout?.should be_true
      settlement.failed?.should be_false
    end
  end
end
