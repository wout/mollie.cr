struct Mollie
  struct Mixins
    module Linkable
      @[JSON::Field(key: "_links")]
      getter links : Hash(String, Hash(String, String))?
    end
  end
end
