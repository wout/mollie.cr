require "../spec_helper.cr"
require "../spec_helpers/base_helper.cr"

describe Mollie::TestObject do
  describe "#resource_name" do
    it "returns the name of a resource" do
      Mollie::TestObject.resource_name
        .should eq("testobjects")
    end
  end

  describe ".get" do
    it "performs a get request" do
      WebMock.stub(:get, "https://api.mollie.com/v2/testobjects/mastaba")
        .to_return(body: test_object_json)

      resource = Mollie::TestObject.get("mastaba")
      resource.id.should eq("mastaba")
    end
  end

  describe ".id_param" do
    it "generates the id parameter for the current class" do
      Mollie::TestObject.id_param.should eq("testobject_id")
    end
  end

  describe ".parent_id_param" do
    it "returns nothing if no parent_id_param exists" do
      Mollie::TestObject.parent_id_param.should be_nil
    end
  end

  describe ".from_json" do
    it "serializes the given json" do
      json = JSON.parse(test_object_json)
      object = Mollie::TestObject.from_json(test_object_json)
      object.id.should eq(json["id"])
      object.foo.should eq(json["foo"])
      object.my_field.should eq(json["myField"])
    end
  end
end

describe Mollie::TestObject::NestedObject do
  describe "#resource_name" do
    it "returns the name of a nested resource" do
      Mollie::TestObject::NestedObject.resource_name("object-id")
        .should eq("testobjects/object-id/nestedobjects")
    end
  end

  describe ".id_param" do
    it "generates the id parameter for the current class" do
      Mollie::TestObject::NestedObject.id_param.should eq("nestedobject_id")
    end
  end

  describe ".parent_id_param" do
    it "generates the id parameter for the parent class" do
      Mollie::TestObject::NestedObject.parent_id_param.should eq("testobject_id")
    end
  end

  describe ".from_json" do
    it "serializes the given json" do
      json = JSON.parse(nested_test_object_json)
      object = Mollie::TestObject::NestedObject.from_json(nested_test_object_json)
      object.id.should eq(json["id"])
      object.foo.should eq(json["foo"])
      object.testobject_id.should eq(json["testobjectID"])
    end
  end
end

struct Mollie
  class TestObject < Base
    include JSON::Serializable

    getter id : String?
    getter foo : String?
    @[JSON::Field(key: "myField")]
    getter my_field : String?

    class NestedObject < Base
      include JSON::Serializable

      getter id : String?
      getter foo : String?
      @[JSON::Field(key: "testobjectID")]
      getter testobject_id : String?
    end
  end
end
