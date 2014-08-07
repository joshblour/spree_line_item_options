class AddOptionsToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :options, :json
  end
end
