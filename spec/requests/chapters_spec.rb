# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChaptersController, type: :request do
  describe 'GET /books/:book_id/chapters/:position' do
    let(:book) { create(:book) }
    let!(:chapter) { create(:chapter, book: book, position: 1) }

    it 'returns a successful response' do
      get book_chapter_path(book, chapter)
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct chapter' do
      get book_chapter_path(book, chapter)
      expect(response.body).to include(chapter.title)
    end

    it 'returns a 404 for a non-existent chapter' do
      get book_chapter_path(book, 'non-existent-position')
      expect(response).to have_http_status(:not_found)
    end

    it 'returns the previous and next chapters' do
      create(:chapter, book: book, position: 2)

      get book_chapter_path(book, chapter)
      expect(response.body).not_to include('Previous Chapter')
      expect(response.body).to include('Next Chapter')
    end
  end
end
