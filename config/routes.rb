# frozen_string_literal: true

Rails.application.routes.draw do
  root 'books#index'

  namespace :admin do
    resources :books do
      resources :book_translations, param: :id
      resources :chapters, param: :position do
        resources :chapter_translations, param: :id
      end
    end
  end

  resources :books, only: %i[index show] do
    resources :chapters, only: [:show], param: :position
  end
end
