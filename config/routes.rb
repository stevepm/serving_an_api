Rails.application.routes.draw do
  resources :makes, only: [:index, :show, :create]
  resources :cars, only: [:index, :show, :create]

end
