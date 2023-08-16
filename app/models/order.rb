class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  accepts_nested_attributes_for :order_items 

  enum status: { ordered: 0, paid: 1, completed: 2, cancelled: 3 }

  def total
    order_items.sum(&:subtotal)
  end

  def cancel!
    update(status: :cancelled)
  end

  def mark_paid!
    update(status: :paid)
  end

  def mark_completed!
    update(status: :completed)
  end

  before_destroy :recalculate_total

  def recalculate_total
    self.total = order_items.sum(&:subtotal)
  end
end
