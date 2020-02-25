struct Mollie
  struct Json
    struct ListConverter(T)
      def self.from_json(pull : JSON::PullParser)
        items = Array(T).new
        pull.read_object do |key|
          if key == collection_key
            pull.read_array do
              items.push(T.from_json(pull.read_raw))
            end
          end
        end
        items
      end

      def self.collection_key
        name = {{ T.id }}.name.split("::").last.downcase
        Wordsmith::Inflector.pluralize(name)
      end
    end
  end
end
