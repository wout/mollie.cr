module Mollie
  struct Profile < Base::Resource
    include Mixins::Linkable

    enum CategoryCode
      AdvisingCoachingTraining      = 8299
      Alcohol                       = 5921
      AutomotiveProducts            = 5533
      BooksMagazinesAndNewspapers   = 5192
      CharityAndDonations           = 8398
      ChildrenProducts              = 5641
      ClothingShoes                 = 5651
      Consultancy                   = 7299
      CreditsVouchersGiftcards      = 5815
      ElectronicsComputersSoftware  = 5732
      Entertainment                 = 5735
      FinancialServices             = 6012
      FoodAndDrinks                 = 5499
      GeneralMerchandise            = 5399
      HealthBeautyProducts          = 5977
      HostingVpnServices            = 5734
      JewelryAccessories            = 5944
      Other                         =    0
      PoliticalParties              = 8699
      TravelRentalAndTransportation = 7999
    end

    enum Status
      Blocked
      Unverified
      Verified
    end

    status_enum_methods

    json_field(:category_code, Int32)
    json_field(:created_at, Time)
    json_field(:email, String)
    json_field(:id, String)
    json_field(:mode, String)
    json_field(:name, String)
    json_field(:phone, String)
    json_field(:review, Mollie::Profile::Review)
    json_field(:status, String)
    json_field(:website, String)

    def checkout_preview_url
      link_for(:checkout_preview_url)
    end

    {% begin %}
      {% for method in %w[chargeback method payment refund] %}
        def {{ "#{method.id}s".id }}(options : Hash | NamedTuple = HS2.new)
          {{ method.camelcase.id }}.all(options.to_h.merge({:profile_id => id}))
        end
      {% end %}
    {% end %}

    struct Review < Base::Resource
      enum Status
        Pending
        Rejected
      end

      status_enum_methods

      json_field(:status, String)
    end
  end
end
