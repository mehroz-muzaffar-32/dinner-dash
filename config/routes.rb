Rails.application.routes.draw do
  root to: 'restaurants#index'

  devise_for :users

  resources :line_items, only: :destroy do
    post :add_quantity
    post :reduce_quantity
  end

  resources :items, only: :index do
    resources :line_items, only: :create
    post :update_status
  end

  resources :restaurants do
    resources :items, shallow: true
  end

  scope '/:item_id', controller: :session_carts do
    post :add_line_item
    post :add_quantity
    post :reduce_quantity
    delete :remove_line_item
  end

  resource :cart, only: %i[show destroy]
  resolve('Cart') { :cart }

  resources :orders, only: %i[index show update] do
    post :checkout, on: :collection
  end

  resources :categories do
    get :category_items, as: :items
    post :add_item
    post :remove_item
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
