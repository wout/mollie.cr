require "../spec_helper.cr"

describe Mollie::VERSION do
  it "returns the current version" do
    Mollie::VERSION.should eq(`git describe --abbrev=0 --tags`.strip)
  end
end
