class AddOrderToCartItems < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_items, :order, :integer
  end
end
