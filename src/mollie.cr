require "big"
require "json"
require "http/client"
require "wordsmith"
require "./mollie/mixins/**"
require "./mollie/json/**"
require "./mollie/**"

alias HS2 = Hash(String, String)
alias HSHS2 = Hash(String, HS2)
alias HSBFIS = Hash(String, Bool | Float64 | Int32 | String)

struct Mollie
  def self.configure
    yield(Mollie::Config)
  end
end
