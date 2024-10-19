require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users
  
  resources :adjustments
  resources :wallets

  resources :loans do
    member do
      post :approve
      post :reject
      post :adjust
      post :repay
      patch :update_status
    end
  end

  root to: 'loans#index'
end