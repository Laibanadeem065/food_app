class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item
  attribute :order, :integer


  def subtotal
    quantity.present? && item.present? ? quantity * item.price : 0
  end
end



