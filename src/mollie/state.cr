module Mollie
  module State
    class_property instances = Hash(String, Client).new

    def self.clear
      instances.clear
    end
  end
end
