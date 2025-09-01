# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome/index'
  mount_devise_token_auth_for 'User', at: 'users', controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  resources :groups, only: [:update]
  resources :companies, only: [:create]
  resources :skills, only: [:index]
  resources :teams, only: %i[create index show destroy update] do
    resources :enrollments, only: %i[create destroy], module: :teams do
      resources :approvals, only: [:create], module: :enrollments
    end
  end
end
