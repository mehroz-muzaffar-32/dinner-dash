Rails.application.routes.draw do
  root to: 'restaurants#index'

  devise_for :users

  resources :line_items, only: %i[update destroy]

  resources :items, only: :index do
    resources :line_items, only: :create
  end

  resources :restaurants do
    resources :items, shallow: true, except: :index do
      resource :session_line_item, only: %i[create update destroy]
    end
  end

  resource :cart, only: %i[show destroy]
  resolve('Cart') { :cart }

  resources :orders, only: %i[index show update create]

  resources :categories do
    resources :categories_items, shallow: true
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
