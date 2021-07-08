# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  resources :companies

  namespace :api, format: :json do
    mount_devise_token_auth_for 'User', at: 'users', controllers: {
      registrations: 'api/users/registrations'
    }

    resources :groups, only: [:update]
    resources :companies, only: [:create]
    resources :skills, only: [:index]
    resources :teams, only: [:create, :index] do
      resources :enrollments, only: [:create, :destroy], module: :teams do
        resources :approvals, only: [:create], module: :enrollments
      end
    end
  end
end
