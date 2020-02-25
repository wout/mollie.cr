struct Mollie
  struct Json
    class ListConverter(T)
      def self.from_json(pull : JSON::PullParser)
        return items = Array(Mollie::Mastaba).new
        pull.read_object do |key|
          if key == "products"
            pull.read_array do
              items.push(Mollie::Mastaba.from_json(pull.read_raw))
            end
          end
        end
        items
      end

      def self.to_json(value : self, json : JSON::Builder)
        json.object({:name_here => json.array(value)})
      end
    end
  end
end

# class ListConverter
#   def self.from_json(pull : JSON::PullParser)
#     items = Array(Item).new
#     pull.read_object do |key|
#       if key == "products"
#       pull.read_array do
#         items.push(Item.from_json(pull.read_raw))
#       end
#       end
#     end
#     items
#   end
#   def self.to_json(value : self, json : JSON::Builder)
#   end
# end

# struct Item
#   include JSON::Serializable
#   getter id : String?

#   @[JSON::Field(key: "_embedded", converter: ListConverter)]
#   getter items : Array(Item)?

# end

# item_json = %({
#   "id":"tr_21",
#   "_embedded": {
#     "products": [
#       {"id":"tr_22"}
#     ]
#   }
# })

# item = Item.from_json(item_json)
# puts item.id
# puts item.items
