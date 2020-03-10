struct Mollie
  struct Order
    struct Line < Base::Line
      def cancel(options : Hash | NamedTuple = HS2.new)
        options = Util.stringify_keys(options)
        qty = options.delete("quantity") || quantity
        delete(options.merge({
          :lines    => [{:id => id, :quantity => qty}],
          :order_id => order_id,
        }))
      end
    end
  end
end
