struct Mollie
  module Config
    class_property api_key : String?
    class_property open_timeout : Int32 | Float64 = 60
    class_property read_timeout : Int32 | Float64 = 60
  end
end
