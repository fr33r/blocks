# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    resources :formats, only: %i[index show create] do
      resources :files, only: %i[index show create] do
        resources :rows, only: %i[index show create update]
      end
      resources :pipelines, only: %i[index show create] do
        resources :rules, only: %i[index show create update]
      end
    end
  end

  resources :rows, only: %i[index show create update]

  mount RailsEventStore::Browser => '/res' if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
