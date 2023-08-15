class ItemsController < ApplicationController
    before_action :set_item, only: [:show]
    before_action :authenticate_user!
    skip_before_action :authenticate_user!, only: [:index, :show,:by_category]
  
    def index
      if params[:query].present?
        query = params[:query].downcase # Convert the query to lowercase
        @items = Item.where("LOWER(title) LIKE ?", "%#{query}%")
      else
        @items = policy_scope(Item)
      end
    end    
  
    def show
    end
  
    def new
      @item = Item.new
      authorize @item
    end
  
    def create
      @item = current_user.items.new(item_params)
      authorize @item
      respond_to do |format|
        if @item.save
          format.html { redirect_to item_url(@item), notice: "Item was successfully created." }
          format.json { render :show, status: :created, location: @item }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def edit
      @item = Item.find(params[:id])
      authorize @item
    
    end
  
    def update
      @item = Item.find(params[:id])
      @item.user = current_user
      authorize @item
 
      respond_to do |format|
        if @item.update(item_params)
          format.html { redirect_to item_url(@item), notice: "Item was successfully updated." }
          format.json { render :show, status: :ok, location: @item }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @item = Item.find(params[:id])
      authorize @item
     
      @item.destroy
      respond_to do |format|
        format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def by_category
      @category = Category.find_by(name: params[:category])
      @items = @category.items if @category.present?
    end

    def retire_item
      item = Item.find(params[:id])
      item.update(retired: true)
      redirect_to items_path, notice: "Item retired successfully."
    end
    def search
      @items = Item.where("title LIKE ?", "%#{params[:query]}%")
    end
    

    
  
    private
  
    def set_item
      @item = Item.find(params[:id])
    end
  
    def item_params
      params.require(:item).permit(:title, :description, :price, :photo, :retired, category_ids: [])
    end
  end