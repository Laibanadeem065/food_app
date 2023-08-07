class OrdersController < ApplicationController
  
    def index
      @orders = current_user.orders
    end
  
    def show
      @order = current_user.orders.find(params[:id])
    end
  
    def create
      @order = current_user.orders.build
      params[:item_ids].each do |item_id|
        @order.order_items.build(item_id: item_id)
      end
  
      if @order.save
        redirect_to @order, notice: "Order created successfully."
      else
        redirect_to cart_path, alert: "Failed to create order."
      end
    end

    def checkout
      @cart_items = current_cart.cart_items.includes(:item)
    
      if @cart_items.empty?
        redirect_to cart_path, notice: "Your cart is empty."
        return
      end
    
      if user_signed_in?
        @order = current_user.orders.build
        @cart_items.each do |cart_item|
          @order.order_items.build(item: cart_item.item, quantity: cart_item.quantity)
        end
    
        if @order.save
          current_cart.cart_items.destroy_all
          redirect_to @order, notice: "Checkout successful. Your order has been placed."
        else
          redirect_to cart_path, alert: "Failed to place the order. Please try again."
        end
      else
        redirect_to new_user_session_path, alert: "You need to sign in before checking out."
      end
    end
    
  
    private
  
    def order_params
      params.require(:order).permit(:item_ids, :status)
    end
end