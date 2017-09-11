Rails.application.routes.draw do
  resources :accounts do
    patch :get_balance, on: :member
    get :get_balance, on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
