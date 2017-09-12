Rails.application.routes.draw do
  resources :accounts do
    patch :get_balance, on: :member
    get :get_balance, on: :member
  end
  
  get 'redirect', to: 'sessions#redirect'
  post 'reset', to: 'sessions#reset'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
