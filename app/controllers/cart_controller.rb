class CartController < ApplicationController
  before_action :set_cart

  def index
    @cart_items = @cart.cart_items.includes(:item).order(:order)
  end

  def add_item
    item = Item.find(params[:item_id])
    if item.retired?
      redirect_to item_path(item), alert: "This item is retired and cannot be added to the cart."
      return
    end
    
    cart_item = @cart.cart_items.find_by(item: item)

    if cart_item
      cart_item.increment!(:quantity)
    else
      next_order = @cart.cart_items.maximum(:order).to_i + 1
      @cart.cart_items.create(item: item, quantity: 1, order: next_order)
    end

    redirect_to cart_path, notice: "Item added to cart successfully."
  end

  def remove_item
    item = Item.find(params[:item_id])
    @cart.cart_items.find_by(item: item)&.destroy

    redirect_to cart_path, notice: "Item removed from cart successfully."
  end

  def increase_quantity
    item = Item.find(params[:item_id])
    cart_item = @cart.cart_items.find_by(item: item)
  
    if cart_item
      cart_item.increment!(:quantity)
      redirect_to cart_path, notice: "Quantity increased successfully."
    else
      redirect_to cart_path, alert: "Item not found in cart."
    end
  end
  

  def decrease_quantity
    item = Item.find(params[:item_id])
    cart_item = @cart.cart_items.find_by(item: item)
  
    if cart_item
      if cart_item.quantity > 1
        cart_item.decrement!(:quantity)
      else
        cart_item.destroy
      end
      redirect_to cart_path, notice: "Quantity decreased successfully."
    else
      redirect_to cart_path, alert: "Item not found in cart."
    end
  end
  

  private

  def set_cart
    if user_signed_in?
      if session[:cart_id].present?
        @cart = current_user.cart || create_cart_for_user
        transfer_temporary_items_to_user_cart
      else
        @cart = current_user.cart || create_temporary_cart
      end
    else
      session_id = session[:custom_session_id] || generate_session_id
      session[:custom_session_id] ||= session_id
      @cart = find_or_create_temporary_cart(session_id)
    end
  end
  
  def create_cart_for_user
    cart = Cart.find_or_create_by(user: current_user)
    session[:cart_id] = cart.id
    cart
  end
  
  def transfer_temporary_items_to_user_cart
    temporary_cart = Cart.find_by(session_id: session[:cart_id])
    return if temporary_cart.nil?
  
    temporary_cart.cart_items.each do |cart_item|
      @cart.add_item(cart_item.item, cart_item.quantity)
    end
  
    temporary_cart.destroy
    session.delete(:cart_id)
  end
  
  def generate_session_id
    SecureRandom.uuid
  end
  
  def find_or_create_temporary_cart(session_id)
    cart_id = session[:cart_id]
    if cart_id
      Cart.find_by(id: cart_id) || create_temporary_cart(session_id)
    else
      create_temporary_cart(session_id)
    end
  end
  

  def create_temporary_cart(session_id = nil)
    cart = Cart.create(session_id: session_id)
    session[:cart_id] = cart.id
    cart
  end
  
  
  
  
end




