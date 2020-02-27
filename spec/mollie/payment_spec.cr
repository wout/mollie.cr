require "../spec_helper.cr"
require "../spec_helpers/payment_helper.cr"

describe Mollie::Payment do
  describe "Status enum" do
    describe "#to_s" do
      it "converts to lower case" do
        Mollie::Payment::Status::Paid.to_s.should eq("paid")
      end
    end

    describe "#==" do
      it "tests against a lower case string" do
        (Mollie::Payment::Status::Paid == "paid").should be_true
      end
    end
  end

  describe "#links" do
    it "is linkable" do
      payment = Mollie::Payment.from_json(get_payment_json)
      payment.links.should be_a(Hash(String, Hash(String, String)))
    end
  end

  describe ".from_json" do
    it "pulls the required attributes" do
      payment = Mollie::Payment.from_json(get_payment_json)

      payment.id.should eq("tr_7UhSN1zuXS")
      payment.description.should eq("My first payment")
      payment.created_at.should eq(Time.parse_rfc3339("2018-03-20T09:13:37+00:00"))
      payment.status.should eq("paid")
      payment.authorized_at.should eq(Time.parse_rfc3339("2018-03-19T09:14:37+00:00"))
      payment.paid_at.should eq(Time.parse_rfc3339("2018-03-20T09:14:37+00:00"))
      payment.amount.should be_a(Mollie::Amount)
      payment.description.should eq("My first payment")
      payment.method.should eq("ideal")
    end
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      payment = Mollie::Payment.from_json(get_payment_json)
      payment.open?.should be_false
      payment.canceled?.should be_false
      payment.pending?.should be_false
      payment.expired?.should be_false
      payment.failed?.should be_false
      payment.paid?.should be_true
      payment.authorized?.should be_false
    end
  end
end
