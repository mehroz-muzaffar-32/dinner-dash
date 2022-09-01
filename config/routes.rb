Rails.application.routes.draw do
  root to: 'restaurants#index'
  devise_for :users
  resources :restaurants do
    resources :items, shallow: true
  end
  resources :items, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
