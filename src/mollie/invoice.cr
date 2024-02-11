module Mollie
  struct Invoice < Base::Resource
    include Mixins::Linkable

    enum Status
      Open
      Paid
      Overdue
    end

    status_enum_methods

    json_field(:due_at, String)
    json_field(:gross_amount, Amount)
    json_field(:id, String)
    json_field(:issued_at, String)
    json_field(:lines, Array(Mollie::Invoice::Line))
    json_field(:net_amount, Amount)
    json_field(:paid_at, Time?)
    json_field(:reference, String)
    json_field(:status, String)
    json_field(:vat_amount, Amount)
    json_field(:vat_number, String)

    def pdf
      link_for(:pdf)
    end

    struct Line
      include Json::Serializable

      json_field(:amount, Amount)
      json_field(:count, Int32)
      json_field(:description, String)
      json_field(:period, String)
      json_field(:vat_percentage, Float64)
    end
  end
end
