module Spree
  OrderPopulator.class_eval do

    #
    # Parameters can be passed using the following possible parameter configurations:
    #
    # * Single variant/quantity pairing
    # +:variants => { variant_id => quantity }+
    #
    # * Multiple products at once
    # +:products => { product_id => variant_id, product_id => variant_id }, :quantity => quantity+
    
    
    # YONAH: changed to include options from line item (must use fields_for). options hash just gets serialized on the line item.
    # will increment existing line items if the options match exactly (contents or empty). otherwise creates
    # new line item.
    def populate(from_hash)
      from_hash[:options] ||= {}
      options_hash = from_hash[:options].reject {|k,v| v.empty?} ## added
      from_hash[:products].each do |product_id,variant_id|
        attempt_cart_add(variant_id, from_hash[:quantity], options_hash)  ## changed
      end if from_hash[:products]

      from_hash[:variants].each do |variant_id, quantity|
        attempt_cart_add(variant_id, quantity, options_hash) ## changed
      end if from_hash[:variants]

      valid?
    end

    private
    
    # YONAH: changed to include options from line item (must use fields_for). options hash just gets serialized on the line item.
    # will increment existing line items if the options match exactly (contents or empty). otherwise creates
    # new line item.
    def attempt_cart_add(variant_id, quantity, options = {})  ## changed
      quantity = quantity.to_i
      # 2,147,483,647 is crazy.
      # See issue #2695.
      if quantity > 2_147_483_647
        errors.add(:base, Spree.t(:please_enter_reasonable_quantity, :scope => :order_populator))
        return false
      end

      variant = Spree::Variant.find(variant_id)
      if quantity > 0
        line_item = @order.contents.add(variant, quantity, currency, nil, options)  ## changed
        unless line_item.valid?
          errors.add(:base, line_item.errors.messages.values.join(" "))
          return false
        end
      end
    end
  end
end
