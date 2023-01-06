# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    resources :formats, only: %i[index show create], controller: 'file_formats' do
      resources :files, only: %i[index show create] do
        resources :rows, only: %i[index show create update] do
          match '/', to: 'rows#patch', via: %i[patch], on: :member
          match '/', to: 'rows#patch_collection', via: %i[patch], on: :collection
        end
      end
      resources :pipelines, only: %i[index show create] do
        resources :rules, only: %i[index show create] do
          match '/', to: 'rules#patch', via: %i[patch], on: :member
        end
      end
    end
  end

  resources :rows, only: %i[index show create update edit new]
  resources :formats, only: %i[index show], controller: 'file_formats'

  mount RailsEventStore::Browser => '/res' if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
