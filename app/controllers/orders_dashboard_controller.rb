class OrdersDashboardController < ApplicationController
    def index
      @orders = Order.all
    end
  
    def show
      @order = Order.find(params[:id])
    end
  
    def cancel
      order = Order.find(params[:id])
      order.cancel!
      redirect_to orders_dashboard_path, notice: "Order cancelled successfully."
    end
  
    def mark_paid
      order = Order.find(params[:id])
      order.mark_paid!
      redirect_to orders_dashboard_path, notice: "Order marked as paid successfully."
    end
  
    def mark_completed
      order = Order.find(params[:id])
      order.mark_completed!
      redirect_to orders_dashboard_path, notice: "Order marked as completed successfully."
    end
  end