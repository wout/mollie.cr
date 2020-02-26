struct Mollie
  module State
    class_property instances = Hash(String, Mollie::Client).new
  end
end
