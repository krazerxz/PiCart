Rails.application.routes.draw do
  resource :product

  root 'products#index'
end
