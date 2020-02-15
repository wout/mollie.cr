struct Mollie
  module Util
    def self.extract_url(links : Hash, type : String)
      links.dig?(type, "href")
    end

    def self.extract_id(links : Hash, type : String)
      href = extract_url(links, type)
      return if href.nil?
      uri = URI.parse(href)
      File.basename(uri.path)
    end
  end
end
