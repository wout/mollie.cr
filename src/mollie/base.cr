struct Mollie
  abstract class Base
    def self.resource_name(parent_id : String? = nil)
      parts = name.downcase.split("::")
      path = parts[1..-1].map { |p| Wordsmith::Inflector.pluralize(p) }

      if path.size == 2 && parent_id
        path.join("/#{parent_id}/")
      else
        path.last
      end
    end
  end
end
