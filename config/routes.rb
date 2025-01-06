# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check
  root "books#index"

  resources :books do
    resources :book_translations, path: 'translations'
    resources :chapters, param: :position do
      resources :chapter_translations, path: 'translations'
    end
  end
end
