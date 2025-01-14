# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Books', type: :request do
  let!(:book) { create(:book) } # Assuming you have a factory for Book

  describe 'GET /admin/books' do
    it 'returns a successful response' do
      get admin_books_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /admin/books/:id' do
    it 'returns a successful response' do
      get admin_book_path(book)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /admin/books/new' do
    it 'returns a successful response' do
      get new_admin_book_path
      expect(response).to redirect_to(admin_books_path)
    end
  end

  describe 'POST /admin/books' do
    context 'with valid parameters' do
      it 'creates a new book and responds with Turbo Stream' do
        post admin_books_path, params: { book: { title: 'New Book', description: 'Description', language: 'en' } },
                               headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
        expect(flash.now[:notice]).to eq('Book was successfully created.')
        expect(Book.count).to eq(2)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new book and responds with Turbo Stream' do
        post admin_books_path, params: { book: { title: '', description: '', language: '' } },
                               headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
      end
    end
  end

  describe 'GET /admin/books/:id/edit' do
    it 'returns a successful response' do
      get edit_admin_book_path(book)
      expect(response).to redirect_to(admin_book_path(book))
    end
  end

  describe 'PATCH /admin/books/:id' do
    context 'with valid parameters' do
      it 'updates the book and responds with Turbo Stream' do
        patch admin_book_path(book), params: { book: { title: 'Updated Title' } },
                                     headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
        expect(book.reload.title).to eq('Updated Title')
        expect(flash.now[:notice]).to eq('Book was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the book and responds with Turbo Stream' do
        patch admin_book_path(book), params: { book: { title: '' } },
                                     headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
      end
    end
  end

  describe 'DELETE /admin/books/:id' do
    it 'destroys the book' do
      expect do
        delete admin_book_path(book)
      end.to change(Book, :count).by(-1)
      expect(response.content_type).to eq('text/html; charset=utf-8')
    end
  end

  describe 'GET /admin/books/:id/new_translation' do
    it 'returns a successful response for Turbo Stream' do
      get new_translation_admin_book_path(book), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
    end

    it 'redirects to admin_books_path for HTML' do
      get new_translation_admin_book_path(book)
      expect(response).to redirect_to(admin_books_path)
    end
  end

  describe 'POST /admin/books/:id/create_translation' do
    context 'with valid parameters' do
      it 'creates a new translation and responds with Turbo Stream' do
        post create_translation_admin_book_path(book),
             params: { book: { title: 'Translation Title', description: 'Translation Description', language: book.available_languages.sample } }, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
        expect(flash.now[:notice]).to eq('Translation was successfully created.')
        expect(book.translations.count).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new translation and responds with Turbo Stream' do
        post create_translation_admin_book_path(book), params: { book: { title: '', description: '', language: '' } },
                                                       headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
      end
    end
  end
end
