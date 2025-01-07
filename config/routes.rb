# frozen_string_literal: true

Rails.application.routes.draw do
  root 'books#index'

  namespace :admin do
    resources :books do
      resources :book_translations, param: :language do
        get :edit, on: :member
      end
      resources :chapters, param: :position do
        resources :chapter_translations, param: :language do
          get :edit, on: :member
        end
      end
    end
  end

  resources :books, only: %i[index show] do
    resources :chapters, only: [:show], param: :position
  end
end
