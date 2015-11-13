Rails.application.routes.draw do
  resources :lists
  resources :products

  root 'products#index'
end
