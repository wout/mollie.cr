struct Mollie
  struct Mixins
    module Linkable
      @[JSON::Field(key: "_links")]
      getter links : HSHS2?
    end
  end
end
