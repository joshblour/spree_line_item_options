module Spree
  LineItem.class_eval do
    ## serialize options hash on line_items.
    serialize :options, Hash
  end
end