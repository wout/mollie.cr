struct Mollie
  alias HS2 = Hash(String, String)
  alias HSHS2 = Hash(String, HS2)
  alias HSBFIS = Hash(String, Bool | Float64 | Int32 | String)
  alias Links = Hash(String, Hash(String, String)?)
  alias AmountValue = Float64 | Float32 | Int64 | UInt64 | Int32 | UInt32 | String
end
