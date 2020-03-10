struct Mollie
  struct Base
    abstract struct Line < Resource
      include Mixins::Linkable

      json_field(:amount_canceled, Amount?)
      json_field(:amount_refunded, Amount?)
      json_field(:amount_shipped, Amount?)
      json_field(:cancelable_quantity, Int32?)
      json_field(:created_at, Time)
      json_field(:discount_amount, Amount?)
      json_field(:id, String)
      json_field(:is_cancelable, Bool?)
      json_field(:metadata, HSBFIS?)
      json_field(:name, String)
      json_field(:order_id, String)
      json_field(:quantity, Int32)
      json_field(:quantity_canceled, Int32)
      json_field(:quantity_refunded, Int32)
      json_field(:quantity_shipped, Int32)
      json_field(:refundable_quantity, Int32)
      json_field(:shippable_quantity, Int32)
      json_field(:sku, String)
      json_field(:status, String)
      json_field(:total_amount, Amount)
      json_field(:type, String)
      json_field(:unit_price, Amount)
      json_field(:vat_amount, Amount)
      json_field(:vat_rate, String)

      def cancelable?
        !!is_cancelable
      end

      def discounted?
        !!discount_amount
      end

      def shippable?
        shippable_quantity > 0
      end

      def refundable?
        refundable_quantity > 0
      end

      def product_url
        link_for(:product_url)
      end

      def image_url
        link_for(:image_url)
      end
    end
  end
end
