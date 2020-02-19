struct Mollie
  abstract class Base
    alias H = Hash(String, String)

    @@name_parts : Array(String)?

    def self.get(id : String, options : Hash = H.new)
      request("GET", id, H.new, options) do |response|
        from_json(response)
      end
    end

    def self.id_param
      "#{name_parts[-1]}_id"
    end

    def self.parent_id_param
      "#{name_parts[-2]}_id" unless name_parts[-2] == "mollie"
    end

    def self.resource_name(parent_id : String? = nil)
      path = name_parts[1..-1].map { |p| Wordsmith::Inflector.pluralize(p) }

      if path.size == 2 && parent_id
        path.join("/#{parent_id}/")
      else
        path.last
      end
    end

    private def self.request(
      method : String,
      id : String?,
      data : Hash = H.new,
      options : Hash = H.new
    )
      parent_id = options.delete(parent_id_param) || data.delete(parent_id_param)
      response = Mollie::Client.instance.perform_http_call(
        method, resource_name(parent_id), id, data, options)
    end

    private def self.request(
      method : String,
      id : String?,
      data : Hash = H.new,
      options : Hash = H.new
    )
      yield(request(method, id, data, options))
    end

    private def self.name_parts
      @@name_parts ||= name.downcase.split("::")
    end
  end
end
