module Mollie
  struct Json
    struct Underscorer
      def self.from_json(pull : JSON::PullParser)
        hash = HSBFIS.new
        pull.read_object do |key|
          underscored = Wordsmith::Inflector.underscore(key)
          hash[underscored] = case pull.kind
                              when .int?
                                pull.read_int.to_i32
                              when .float?
                                pull.read_float
                              when .bool?
                                pull.read_bool
                              else
                                pull.read_string
                              end
        end
        hash
      end

      def self.to_json(hash : Hash, json : JSON::Builder)
        json.object do
          Util.camelize_keys(hash).each_pair do |key, value|
            json.field(key, value)
          end
        end
      end
    end
  end
end
