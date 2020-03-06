struct Mollie
  module State
    class_property instances = Hash(String, Client).new
  end
end
