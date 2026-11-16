Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :registrations]

  devise_scope :user do
    post "/api/v1/login",
         to: "api/v1/sessions#create"

    delete "/api/v1/logout",
           to: "api/v1/sessions#destroy"
  end

  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          patch :toggle_status
        end
      end
      post "signup", to: "registrations#create"
      get "profile", to: "profiles#show"
      get "stock_report", to: "stock_reports#index"
      resources :companies do
        member do
          patch :toggle_status
        end
      end
      resources :hotels do
        member do
          patch :toggle_status
        end
      end
      resources :categories, only: [:index, :show, :create, :update, :destroy]
      resources :stock_transactions, only: [:index, :create]
      resources :stock_ins, only: [:index, :create]
      resources :stock_outs, only: [:index, :create]

    end
  end
end
