def test_object_json
  %({
    "id": "mastaba",
    "foo": "App noot mies",
    "myField": "Magnificent"
  })
end

def nested_test_object_json
  %({
    "id": "nested",
    "foo": "Wim zus jet",
    "testobject_id": "mastaba"
  })
end
