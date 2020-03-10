require "../spec_helper.cr"

def test_invoice
  Mollie::Invoice.from_json(read_fixture("invoices/get.json"))
end

describe Mollie::Invoice do
  before_each do
    configure_test_api_key
  end

  describe "#links" do
    it "contain links" do
      test_invoice.links.should be_a(Links)
    end
  end

  describe ".from_json" do
    it "pulls the required fields" do
      test_invoice.due_at.should eq("2016-09-14")
      test_invoice.gross_amount.should be_a(Mollie::Amount)
      test_invoice.id.should eq("inv_xBEbP9rvAq")
      test_invoice.issued_at.should eq("2016-08-31")
      test_invoice.lines.should be_a(Array(Mollie::Invoice::Line))
      test_invoice.net_amount.should be_a(Mollie::Amount)
      test_invoice.paid_at.should be_a(Time?)
      test_invoice.reference.should eq("2016.10000")
      test_invoice.status.should eq("open")
      test_invoice.vat_amount.should be_a(Mollie::Amount)
      test_invoice.vat_number.should eq("NL001234567B01")
    end
  end

  describe "boolean status methods" do
    it "defines a boolean method per status" do
      test_invoice.open?.should be_true
      test_invoice.paid?.should be_false
      test_invoice.overdue?.should be_false
    end
  end

  describe "#pdf" do
    it "returns a url to a downloadable pdf" do
      test_invoice.pdf.should eq(test_invoice.link_for(:pdf))
    end
  end
end
