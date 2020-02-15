struct Mollie
  module Util
    def self.version_string
      mollie = Mollie::VERSION
      crystal = Crystal::VERSION
      openssl = LibSSL::OPENSSL_VERSION
      "Mollie/#{mollie} Crystal/#{crystal} OpenSSL/#{openssl}"
    end

    def self.extract_url(links : Hash, type : String)
      links.dig?(type, "href")
    end

    def self.extract_id(links : Hash, type : String)
      href = extract_url(links, type)
      return if href.nil?
      uri = URI.parse(href)
      File.basename(uri.path)
    end

    def self.camelize_keys(hash : Hash(Symbol | String, String))
      hash.each_with_object(Hash(String, String).new) do |(key, value), camel|
        camel[Wordsmith::Inflector.camelize(key, false)] = value
      end
    end

    def self.build_nested_query(
      value : Array(String) | Hash(String, String) | String?,
      prefix : String? = ""
    )
      case value
      when Array
        value.map do |v|
          self.build_nested_query(v, "#{prefix}[]")
        end.join("&")
      when Hash
        value.map do |k, v|
          escaped = prefix ? "#{prefix}[#{self.escape(k)}]" : self.escape(k)
          self.build_nested_query(v, escaped)
        end.reject(&.empty?).join("&")
      when nil
        prefix
      else
        raise ArgumentError.new("value must be a Hash") if prefix.nil?
        "#{prefix}=#{self.escape(value)}"
      end
    end

    private def self.escape(value : String)
      URI.encode_www_form(value)
    end
  end
end
