struct Mollie
  struct Mixins
    module Linkable
      @[JSON::Field(key: "_links")]
      getter links : Links

      def link_for(key : String)
        links.dig(key, "href")
      end

      def link_for?(key : String)
        links.dig?(key, "href")
      end

      def id_from_link(key : String)
        Util.extract_id(link_for(key))
      end

      def id_from_link?(key : String)
        if href = link_for?(key)
          Util.extract_id(href)
        end
      end
    end
  end
end
