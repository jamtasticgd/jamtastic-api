# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  resources :companies

  namespace :api, format: :json do
    mount_devise_token_auth_for 'User', at: 'users'

    resources :groups, only: [:update]
    resources :companies, only: [:create]
    resources :skills, only: [:index]
  end
end
