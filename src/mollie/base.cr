struct Mollie
  abstract class Base
    include JSON::Serializable

    alias HS = Hash(String, String)

    @@name_parts : Array(String)?

    def self.get(id : String, options : Hash = HS.new)
      request(method: "GET", id: id, options: options) do |response|
        from_json(response)
      end
    end

    def self.create(data : Hash = HS.new, options : Hash = HS.new)
      request(method: "POST", data: data, options: options) do |response|
        from_json(response)
      end
    end

    def self.id_param
      "#{name_parts[-1]}_id"
    end

    def self.parent_param
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
      id : String? = nil,
      data : Hash = HS.new,
      options : Hash = HS.new
    )
      data = Util.stringify_keys(data)
      options = Util.stringify_keys(options)
      parent_id = options.delete(parent_param) || data.delete(parent_param)
      response = Mollie::Client.instance.perform_http_call(
        method, resource_name(parent_id.to_s), id, data, options)
    end

    private def self.request(
      method : String,
      id : String? = nil,
      data : Hash = HS.new,
      options : Hash = HS.new
    )
      yield(request(method, id, data, options))
    end

    private def self.name_parts
      @@name_parts ||= name.downcase.split("::")
    end
  end
end
