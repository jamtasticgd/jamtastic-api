# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  resources :companies

  namespace :api, format: :json do
    resources :groups, only: [:update]
  end
end
