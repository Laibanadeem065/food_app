class Item < ApplicationRecord
    has_many :categorizations, dependent: :destroy
    has_many :categories, through: :categorizations
    has_many :order_items
    has_many :orders, through: :order_items
    has_many :cart_items
    has_many :carts, through: :cart_items
    belongs_to :user

    after_update :remove_associations_if_inactive

    validates :title, :description, :price, presence: true
    validates :title, uniqueness: true
    validates :price, numericality: { greater_than: 0 }
    
    has_one_attached :photo


    def available?
      active && !retired
    end

    def retired?
      retired
    end


    def remove_associations_if_inactive
      if saved_change_to_active? && !active?
        order_items.update_all(item_id: nil)
      end
    end

end
