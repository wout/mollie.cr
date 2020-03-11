struct Mollie
  alias HS2 = Hash(String, String)
  alias HSHS2 = Hash(String, HS2)
  alias HSBFIS = Hash(String, Bool | Float64 | Int32 | String)
  alias Links = Hash(String, Hash(String, String)?)
end
