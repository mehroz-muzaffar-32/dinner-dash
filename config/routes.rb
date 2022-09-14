Rails.application.routes.draw do
  root to: 'restaurants#index'
  # root to: 'application#index'
  devise_for :users
  resources :line_items do
    post 'add', action: 'add_quantity', as: 'add'
    post 'reduce', action: 'reduce_quantity', as: 'reduce'
  end
  resources :items, only: [:index] do
    post 'add_to_cart', to: 'line_items#create'
    get 'update_status/:status', action: 'update_status', as: :update_status
  end
  resources :restaurants do
    resources :items, shallow: true
  end
  scope '/:item_id', controller: :session_carts do
    post 'add_to_cart', action: 'add_line_item', as: 'add_line_item'
    delete 'remove_from_cart', action: 'remove_line_item', as: 'remove_line_item'
    post 'add_quantity', action: 'add_quantity', as: 'add_quantity'
    post 'reduce_quantity', action: 'reduce_quantity', as: 'reduce_quantity'
  end
  resource :cart
  resolve('Cart') { [:cart] }

  resources :orders, only: %i[index show update] do
    collection do
      post 'checkout', action: 'checkout', as: 'checkout'
      get ':order_status', action: 'index', as: :by_status, constraints: { order_status: /[a-zA-Z]+/ }
    end
  end
  resources :categories do
    get 'items', action: 'category_items'
    post 'add_item/', action: 'add_item', as: :add_item
    get 'remove_item/:item_id', action: 'remove_item', as: :remove_item
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
