# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Chapters', type: :request do
  let!(:book) { create(:book) } # Assuming you have a factory for Book
  let!(:chapter) { create(:chapter, book: book) } # Assuming you have a factory for Chapter

  describe 'GET /admin/books/:book_id/chapters/:id' do
    it 'returns a successful response' do
      get admin_book_chapter_path(book, chapter.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /admin/books/:book_id/chapters/new' do
    it 'returns a successful response' do
      get new_admin_book_chapter_path(book)
      expect(response).to redirect_to(admin_book_chapters_path(book))
    end
  end

  describe 'POST /admin/books/:book_id/chapters' do
    context 'with valid parameters' do
      it 'creates a new chapter and responds with Turbo Stream' do
        post admin_book_chapters_path(book),
             params: { chapter: { title: 'New Chapter', content: 'Content', position: 1 } }, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
        expect(flash.now[:notice]).to eq('Chapter was successfully created.')
        expect(book.chapters.count).to eq(2)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new chapter and responds with Turbo Stream' do
        post admin_book_chapters_path(book), params: { chapter: { title: '', content: '', position: nil } },
                                             headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
      end
    end
  end

  describe 'GET /admin/books/:book_id/chapters/:id/edit' do
    it 'returns a successful response' do
      get edit_admin_book_chapter_path(book, chapter.id)
      expect(response).to redirect_to(admin_book_chapters_path(book))
    end
  end

  describe 'PATCH /admin/books/:book_id/chapters/:id' do
    context 'with valid parameters' do
      it 'updates the chapter and responds with Turbo Stream' do
        patch admin_book_chapter_path(book, chapter.id), params: { chapter: { title: 'Updated Title' } },
                                                         headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
        expect(chapter.reload.title).to eq('Updated Title')
        expect(flash.now[:notice]).to eq('Chapter was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the chapter and responds with Turbo Stream' do
        patch admin_book_chapter_path(book, chapter.id), params: { chapter: { title: '' } },
                                                         headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
      end
    end
  end

  describe 'DELETE /admin/books/:book_id/chapters/:id' do
    it 'destroys the chapter' do
      expect do
        delete admin_book_chapter_path(book, chapter.id)
      end.to change(book.chapters, :count).by(-1)
      expect(response.content_type).to eq('text/html; charset=UTF-8')
    end
  end
end
