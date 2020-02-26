require "big"
require "json"
require "http/client"
require "wordsmith"
require "./mollie/mixins/**"
require "./mollie/**"

struct Mollie
  def self.configure
    yield(Mollie::Config)
  end
end
