struct Mollie
  abstract struct Base
    include JSON::Serializable

    alias HS = Hash(String, String)

    @@name_parts : Array(String)?

    def self.get(id : String, options : Hash | NamedTuple = HS.new)
      request(method: "GET", id: id, options: options) do |response|
        from_json(response)
      end
    end

    def self.create(data : Hash | NamedTuple, options : Hash | NamedTuple = HS.new)
      request(method: "POST", data: data, options: options) do |response|
        from_json(response)
      end
    end

    def self.update(id : String, data : Hash | NamedTuple)
      request(method: "PATCH", id: id, data: data) do |response|
        from_json(response)
      end
    end

    def update(data : Hash | NamedTuple)
      self.class.update(id.to_s, options_with_parent_id(data))
    end

    def self.delete(id : String, options : Hash | NamedTuple = HS.new)
      request("DELETE", id, options)
    end

    def self.cancel(id : String, options : Hash | NamedTuple = HS.new)
      delete(id, options)
    end

    def delete(options : Hash | NamedTuple = HS.new)
      self.class.delete(id.to_s, options_with_parent_id(options))
    end

    def cancel(options : Hash | NamedTuple = HS.new)
      delete(options)
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

    private def parent_id
      {% if @type.name.downcase.split("::")[-2] != "mollie" %}
        {{ (@type.name.downcase.split("::")[-2] + "_id").id }}
      {% end %}
    end

    private def options_with_parent_id(data : Hash | NamedTuple)
      if parent_id
        parent = HS.new
        parent[self.class.parent_param.to_s] = parent_id.to_s
        data = data.to_h.merge(parent)
      end
      data
    end

    private def self.request(
      method : String,
      id : String? = nil,
      data : Hash | NamedTuple = HS.new,
      options : Hash | NamedTuple = HS.new
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
      data : Hash | NamedTuple = HS.new,
      options : Hash | NamedTuple = HS.new,
      &block
    )
      yield(request(method, id, data, options))
    end

    private def self.name_parts
      @@name_parts ||= name.downcase.split("::")
    end
  end
end
