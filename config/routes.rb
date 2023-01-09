Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants, only: [:show] do
    resources :item, except: [:destroy], controller: "merchant_items"
    resources :invoices, only: [:index, :show], controller: "merchant_invoices"
    resources :dashboards, only: [:index]

  end

  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update]
    resources :invoices, only: [:show]
  end


  resources :admin, only: [:index] 
  resources :invoices, only: [:show]
end
