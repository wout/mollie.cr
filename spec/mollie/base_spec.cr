require "../spec_helper.cr"

describe "Mollie::TestObject" do
  describe "#resource_name" do
    it "returns the name of a resource" do
      Mollie::TestObject.resource_name
        .should eq("testobjects")
    end
    it "returns the name of a nested resource" do
      Mollie::TestObject::NestedObject.resource_name("object-id")
        .should eq("testobjects/object-id/nestedobjects")
    end
  end
end

struct Mollie
  class TestObject < Base
    property :id, :foo, :my_field

    def initialize(
      @id : String?,
      @foo : String?,
      @my_field : String?
    )
    end

    class NestedObject < Base
      property :id, :testobject_id, :foo

      def initialize(
        @id : String?,
        @testobject_id : String?,
        @foo : String?
      )
      end
    end
  end
end
