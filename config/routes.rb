# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome/index'
  
  # Swagger documentation routes
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  mount_devise_token_auth_for 'User', at: 'users', controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  # itch.io OAuth routes
  namespace :users do
    get 'itchio_oauth/authorize', to: 'itchio_oauth#authorize'
    get 'itchio_oauth/callback', to: 'itchio_oauth#callback'
    post 'itchio_oauth/callback', to: 'itchio_oauth#callback'
    post 'itchio_oauth/link_account', to: 'itchio_oauth#link_account'
    delete 'itchio_oauth/unlink_account', to: 'itchio_oauth#unlink_account'
  end

  resources :groups, only: [:update]
  resources :companies, only: [:create]
  resources :skills, only: [:index]
  resources :teams, only: %i[create index show destroy update] do
    resources :enrollments, only: %i[create destroy], module: :teams do
      resources :approvals, only: [:create], module: :enrollments
    end
  end
end
