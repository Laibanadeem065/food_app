Rails.application.routes.draw do
  #get 'cart_items/create'
  root 'home#index'
  devise_for :users

  resources :items
  get '/items/category/:category', to: 'items#by_category', as: 'items_by_category'
  get '/items/search', to: 'items#search', as: 'search_items'

  
  resources :orders, only: [:index, :show, :create]do
  get 'checkout', on: :collection
  end
  
  get 'cart', to: 'cart#index'
  get 'cart/add_item', to: 'cart#add_item'
  get 'cart/remove_item', to: 'cart#remove_item'
  get 'cart/increase_quantity', to: 'cart#increase_quantity'
  get 'cart/decrease_quantity', to: 'cart#decrease_quantity'
  
  resources :orders_dashboard, only: [:index, :show] do
    post 'cancel/:id', action: :cancel, as: :cancel
    post 'mark_paid/:id', action: :mark_paid, as: :mark_paid
    post 'mark_completed/:id', action: :mark_completed, as: :mark_completed
  end

  get 'test/index'


  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
