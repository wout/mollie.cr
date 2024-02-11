module Mollie
  struct Mixins
    module Linkable
      @[JSON::Field(key: "_links")]
      getter links : Links

      def link_for(key : Symbol | String)
        links.dig(Util.camelize_key(key.to_s), "href")
      end

      def link_for?(key : Symbol | String)
        links.dig?(Util.camelize_key(key.to_s), "href")
      end

      def id_from_link(key : Symbol | String)
        Util.extract_id(link_for(key))
      end

      def id_from_link?(key : Symbol | String)
        if href = link_for?(key)
          Util.extract_id(href)
        end
      end
    end
  end
end
