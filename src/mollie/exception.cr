struct Mollie
  class Exception < Exception
  end

  class MissingApiKeyException < Mollie::Exception
  end
end
