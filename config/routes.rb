# frozen_string_literal: true

Rails.application.routes.draw do
  root 'books#index'

  namespace :admin do
    resources :books do
      member do
        get :new_translation
        post :create_translation
      end
      resources :chapters, except: [:index]
    end
  end

  resources :books, only: %i[index show] do
    resources :chapters, only: [:show], param: :position
  end
end
