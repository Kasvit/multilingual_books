# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :request do
  describe 'GET /index' do
    it 'returns a successful response' do
      get books_path
      expect(response).to have_http_status(:success)
    end

    it 'returns a list of books' do
      book = create(:book)
      get books_path
      expect(response.body).to include(book.title)
    end
  end

  describe 'GET /show' do
    let(:book) { create(:book) }

    it 'returns a successful response' do
      get book_path(book)
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct book' do
      get book_path(book)
      expect(response.body).to include(book.title)
    end

    it 'returns a 404 for a non-existent book' do
      get book_path('non-existent-id')
      expect(response).to have_http_status(:not_found)
    end
  end
end
