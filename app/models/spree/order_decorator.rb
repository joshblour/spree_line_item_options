module Spree
  Order.class_eval do
    
    # YONAH: Changed to accept options hash and to match line items by options hash as well
    def find_line_item_by_variant(variant, options = {})
      line_items.detect { |line_item| line_item.variant_id == variant.id && line_item.options == options }
    end
  end
end