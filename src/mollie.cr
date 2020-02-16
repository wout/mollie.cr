require "json"
require "http/client"
require "wordsmith"
require "./mollie/**"

struct Mollie
  def self.configure
    yield(Mollie::Config)
  end
end
