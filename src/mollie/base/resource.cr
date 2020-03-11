struct Mollie
  struct Base
    abstract struct Resource
      include Json::Serializable

      @@name_parts : Array(String)?

      def self.all(
        options : Hash | NamedTuple = HS2.new,
        client : Client = Client.instance
      )
        request("GET", options: options, client: client) do |response|
          List(self).from_json(response)
        end
      end

      def self.get(
        id : String,
        options : Hash | NamedTuple = HS2.new,
        client : Client = Client.instance
      )
        request("GET", id: id, options: options, client: client) do |response|
          from_json(response)
        end
      end

      def self.create(
        data : Hash | NamedTuple,
        options : Hash | NamedTuple = HS2.new,
        client : Client = Client.instance
      )
        request("POST", data: data, options: options, client: client) do |response|
          from_json(response)
        end
      end

      def self.update(
        id : String,
        data : Hash | NamedTuple,
        client : Client = Client.instance
      )
        request("PATCH", id: id, data: data, client: client) do |response|
          from_json(response)
        end
      end

      def update(data : Hash | NamedTuple, client : Client = Client.instance)
        self.class.update(id, options_with_parent_id(data), client)
      end

      def self.delete(
        id : String,
        data : Hash | NamedTuple = HS2.new,
        client : Client = Client.instance
      )
        request("DELETE", id: id, data: data, client: client)
      end

      def self.cancel(
        id : String,
        data : Hash | NamedTuple = HS2.new,
        client : Client = Client.instance
      )
        delete(id, data, client)
      end

      def delete(
        data : Hash | NamedTuple = HS2.new,
        client : Client = Client.instance
      )
        self.class.delete(id, options_with_parent_id(data), client)
      end

      def cancel(
        data : Hash | NamedTuple = HS2.new,
        client : Client = Client.instance
      )
        delete(data, client)
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

      macro status_enum_methods
        {% for value in Status.constants %}
          {% downcased = value.stringify.downcase %}
          def {{ downcased.id }}?
            {{ downcased }} == status
          end
        {% end %}
      end

      private def parent_id
        {% begin %}
          {% downcased = @type.name.downcase.split("::")[-2] %}
          {% if downcased != "mollie" %}
            {{ (downcased + "_id").id }}
          {% end %}
        {% end %}
      end

      private def options_with_parent_id(data : Hash | NamedTuple)
        if parent_id
          parent = HS2.new
          parent[self.class.parent_param.to_s] = parent_id.to_s
          data = data.to_h.merge(parent)
        end
        data
      end

      private def self.request(
        method : String,
        id : String? = nil,
        data : Hash | NamedTuple = HS2.new,
        options : Hash | NamedTuple = HS2.new,
        client : Client = Client.instance
      )
        data = Util.stringify_keys(data)
        options = Util.stringify_keys(options)
        parent_id = options.delete(parent_param) || data.delete(parent_param)
        client.perform_http_call(
          method, resource_name(parent_id.as(String?)), id, data, options)
      end

      private def self.request(
        method : String,
        id : String? = nil,
        data : Hash | NamedTuple = HS2.new,
        options : Hash | NamedTuple = HS2.new,
        client : Client = Client.instance
      )
        yield(request(method, id, data, options, client))
      end

      private def self.name_parts
        @@name_parts ||= name.downcase.split("::")
      end
    end
  end
end
