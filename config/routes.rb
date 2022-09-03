Rails.application.routes.draw do
  root to: 'restaurants#index'
  devise_for :users
  resources :restaurants do
    resources :items, shallow: true
    scope :cart, controller: :orders, as: :order do
      get 'add_item/:item_id', action: 'add_item', as: :add_item
      get 'add_line_item/:item_id', action: 'add_line_item', as: :add_line_item
      get 'remove_item/:item_id', action: 'remove_item', as: :remove_item
      get 'remove_line_item/:item_id', action: 'remove_line_item', as: :remove_line_item
    end
  end
  resource :cart, controller: 'orders', as: 'order', only: %i[ new ]
  get 'checkout/(:order_id)', to: 'orders#checkout', as: :order_checkout
  resources :orders, only: %i[ index show ] do
    get ':order_status', action: 'update_status', as: :update_status
  end
  resources :items, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
