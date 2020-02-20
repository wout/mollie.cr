struct Mollie
  module State
    alias ClientHash = Hash(String, Mollie::Client)

    class_property instances : ClientHash = ClientHash.new
  end
end
