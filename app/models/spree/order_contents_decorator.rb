module Spree
  OrderContents.class_eval do

    # Get current line item for variant if exists
    # Add variant qty to line_item
    
    # YONAH: Changed to accept options hash. will increment if options match exactly (empty or otherwise)
    # if options don't match, will create a new line_item
    def add(variant, quantity = 1, currency = nil, shipment = nil, options = {})
      line_item = order.find_line_item_by_variant(variant, options)
      add_to_line_item(line_item, variant, quantity, currency, shipment, options)
    end

    private
    
    # YONAH: accepts options hash. if creating a new line_item, will include options hash. otherwise just
    # increments existing line item.
    def add_to_line_item(line_item, variant, quantity, currency=nil, shipment=nil, options = {})  ## changed
      if line_item
        line_item.target_shipment = shipment
        line_item.quantity += quantity.to_i
        line_item.currency = currency unless currency.nil?
      else
        line_item = order.line_items.new(quantity: quantity, variant: variant, options: options )  ## changed
        line_item.target_shipment = shipment
        if currency
          line_item.currency = currency unless currency.nil?
          line_item.price    = variant.price_in(currency).amount
        else
          line_item.price    = variant.price
        end
      end

      line_item.save
      order.reload
      line_item
    end

  end
end
