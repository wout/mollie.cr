require "../spec_helper.cr"
require "../spec_helpers/base_helper.cr"

describe Mollie::TestObject do
  describe ".get" do
    it "fetches a resource" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/testobjects/mastaba")
        .to_return(status: 200, body: test_object_json)

      resource = Mollie::TestObject.get("mastaba")
      resource.id.should eq("mastaba")
    end
  end

  describe ".create" do
    it "creates a resource" do
      configure_test_api_key
      WebMock.stub(:post, "https://api.mollie.com/v2/testobjects")
        .with(body: %({"amount":1.95}), headers: client_http_headers)
        .to_return(status: 201, body: %({"id":"my-id", "amount":1.0}))

      resource = Mollie::TestObject.create({:amount => 1.95})
      resource.id.should eq("my-id")
      resource.amount.should eq(1.0)
    end

    it "accepts named tuples" do
      configure_test_api_key
      WebMock.stub(:post, "https://api.mollie.com/v2/testobjects?aap=noot")
        .with(body: %({"amount":1.95}), headers: client_http_headers)
        .to_return(status: 201, body: %({"id":"my-id", "amount":1.0}))

      resource = Mollie::TestObject.create({amount: 1.95}, {aap: "noot"})
      resource.id.should eq("my-id")
      resource.amount.should eq(1.0)
    end
  end

  describe ".update" do
    it "updates a resource by id" do
      configure_test_api_key
      WebMock.stub(:patch, "https://api.mollie.com/v2/testobjects/my-id")
        .with(body: %({"amount":1.95}), headers: client_http_headers)
        .to_return(status: 201, body: %({"id":"my-id", "amount":1.0}))

      resource = Mollie::TestObject.update("my-id", {:amount => 1.95})
      resource.id.should eq("my-id")
      resource.amount.should eq(1.0)
    end
  end

  describe "#update" do
    it "updates a resource and returns a new instance" do
      configure_test_api_key
      WebMock.stub(:patch, "https://api.mollie.com/v2/testobjects/my-id")
        .with(body: %({"amount":1.95}), headers: client_http_headers)
        .to_return(status: 201, body: %({"id":"my-id", "amount":1.0}))

      old_resource = Mollie::TestObject.from_json(%({"id": "my-id"}))
      new_resource = old_resource.update({:amount => 1.95})

      new_resource.should_not eq(old_resource)
      new_resource.id.should eq("my-id")
      new_resource.amount.should eq(1.0)
    end
  end

  describe ".resource_name" do
    it "returns the name of a resource" do
      Mollie::TestObject.resource_name.should eq("testobjects")
    end
  end

  describe ".id_param" do
    it "generates the id parameter for the current class" do
      Mollie::TestObject.id_param.should eq("testobject_id")
    end
  end

  describe ".parent_param" do
    it "returns nothing if no parent_param exists" do
      Mollie::TestObject.parent_param.should be_nil
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
  describe ".get" do
    it "fetches a resource" do
      configure_test_api_key
      WebMock.stub(:get, "https://api.mollie.com/v2/testobjects/mastaba/nestedobjects/nested")
        .to_return(status: 200, body: nested_test_object_json)

      resource = Mollie::TestObject::NestedObject.get("nested", {
        :testobject_id => "mastaba",
      })
      resource.id.should eq("nested")
      resource.testobject_id.should eq("mastaba")
    end
  end

  describe ".create" do
    it "creates a resource" do
      configure_test_api_key
      WebMock.stub(:post, "https://api.mollie.com/v2/testobjects/mastaba/nestedobjects")
        .with(
          body: %({"foo":"1.95"}),
          headers: client_http_headers)
        .to_return(
          status: 201,
          body: %({"id":"my-id", "testobject_id":"p-id", "foo":"1.0"}))

      resource = Mollie::TestObject::NestedObject.create({
        :foo           => "1.95",
        :testobject_id => "mastaba",
      })
      resource.id.should eq("my-id")
      resource.testobject_id.should eq("p-id")
      resource.foo.should eq("1.0")
    end
  end

  describe ".update" do
    it "updates a resource by id" do
      configure_test_api_key
      WebMock.stub(:patch, "https://api.mollie.com/v2/testobjects/object-id/nestedobjects/my-id")
        .with(body: %({"foo":"1.95"}), headers: client_http_headers)
        .to_return(status: 201, body: %({"id":"my-id", "foo":"1.0"}))

      resource = Mollie::TestObject::NestedObject.update("my-id", {
        foo:           "1.95",
        testobject_id: "object-id",
      })
      resource.id.should eq("my-id")
      resource.foo.should eq("1.0")
    end
  end

  describe "#update" do
    it "updates a resource and returns a new instance" do
      configure_test_api_key
      WebMock.stub(:patch, "https://api.mollie.com/v2/testobjects/object-id/nestedobjects/my-id")
        .with(body: %({"foo":"1.95"}), headers: client_http_headers)
        .to_return(status: 201, body: %({"id":"my-id", "foo":"1.0"}))

      old_resource = Mollie::TestObject::NestedObject.from_json(
        %({"id": "my-id", "testobject_id": "object-id"}))
      new_resource = old_resource.update({foo: "1.95"})

      new_resource.should_not eq(old_resource)
      new_resource.id.should eq("my-id")
      new_resource.foo.should eq("1.0")
    end
  end

  describe ".resource_name" do
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

  describe ".parent_param" do
    it "generates the id parameter for the parent class" do
      Mollie::TestObject::NestedObject.parent_param.should eq("testobject_id")
    end
  end

  describe ".from_json" do
    it "serializes the given json" do
      json = JSON.parse(nested_test_object_json)
      object = Mollie::TestObject::NestedObject.from_json(nested_test_object_json)
      object.id.should eq(json["id"])
      object.foo.should eq(json["foo"])
      object.testobject_id.should eq(json["testobject_id"])
    end
  end
end

struct Mollie
  struct TestObject < Base
    getter id : String?
    getter foo : String?
    getter amount : Float64?
    @[JSON::Field(key: "myField")]
    getter my_field : String?

    struct NestedObject < Base
      getter id : String?
      getter foo : String?
      getter testobject_id : String?
    end
  end
end
