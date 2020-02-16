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

    def self.nested_underscore_keys(hash : Hash)
      hash.each_with_object(Hash(String, String).new) do |(key, value), underscored|
        underscored_key = Wordsmith::Inflector.underscore(key)
        underscored[underscored_key] = self.nested_underscore_keys(value)
      end
    end

    def self.nested_underscore_keys(array : Array)
      array.map { |item| self.nested_underscore_keys(item) }
    end

    def self.nested_underscore_keys(value : Number | Bool | String?)
      value
    end

    def self.build_nested_query(
      value : Hash(Symbol | String, String),
      prefix : String? = nil
    )
      value.map do |k, v|
        escaped = prefix ? "#{prefix}[#{self.escape(k)}]" : self.escape(k)
        self.build_nested_query(v, escaped)
      end.reject(&.empty?).join("&")
    end

    def self.build_nested_query(value : Array(String), prefix : String? = nil)
      value.map do |v|
        self.build_nested_query(v, "#{prefix}[]")
      end.join("&")
    end

    def self.build_nested_query(value : String, prefix : String)
      "#{prefix}=#{self.escape(value)}"
    end

    def self.build_nested_query(value : Nil, prefix : String? = nil)
      prefix
    end

    private def self.escape(value : Symbol | String)
      URI.encode_www_form(value.to_s)
    end
  end
end
