def test_object_json
  <<-JSON
    {
      "id": "mastaba",
      "foo": "App noot mies",
      "myField": "Magnificent"
    }
  JSON
end

def nested_test_object_json
  <<-JSON
    {
      "id": "nested",
      "foo": "Wim zus jet",
      "testobjectID": "Fabulous"
    }
  JSON
end
