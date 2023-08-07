class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :items, through: :cart_items

  def add_item(item)
    cart_item = cart_items.build(item: item)
    cart_item.save
  end

  def increase_quantity(item)
    cart_item = cart_items.find_by(item: item)
    if cart_item
      cart_item.increment!(:quantity)
    end
  end  

  def decrease_quantity(item)
    cart_item = cart_items.find_by(item_id: item.id)
    if cart_item.present?
      cart_item.decrement!(:quantity)
      cart_item.destroy if cart_item.quantity.zero?
    end
  end

  def total_price
    cart_items.sum { |cart_item| cart_item.subtotal }
  end
  
end
