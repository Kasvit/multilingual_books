# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id               :bigint           not null, primary key
#  description      :string
#  hidden           :boolean          default(FALSE)
#  hidden_reason    :string
#  language         :string           not null
#  published        :boolean          default(FALSE), not null
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  original_book_id :integer
#
# Indexes
#
#  index_books_on_original_book_id               (original_book_id)
#  index_books_on_original_book_id_and_language  (original_book_id,language) UNIQUE
#  index_books_on_published                      (published)
#  index_books_on_title_and_language             (title,language) UNIQUE
#
require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { should have_many(:book_translations).dependent(:destroy) }
    it { should have_many(:chapters).dependent(:destroy) }
  end

  describe 'callbacks' do
    describe 'after_create' do
      let(:book) { create(:book) }

      it 'generates translations for all selected languages' do
        expect(book.book_translations.count).to eq(book.selected_languages.count)
        expect(book.book_translations.pluck(:language)).to match_array(book.selected_languages)
      end

      it 'generates one chapter' do
        expect(book.chapters.count).to eq(1)
        expect(book.chapters.first.position).to eq(1)
      end
    end
  end

  describe '.with_translations_and_chapters' do
    let!(:book) { create(:book) }

    it 'returns book data with translations and chapters' do
      result = described_class.with_translations_and_chapters(id: book.id).first

      expect(result['book_id']).to eq(book.id)
      expect(result['book_translations']).to be_present
      expect(result['chapter_details']).to be_present

      translation = result['book_translations'].first
      expect(translation).to include('language', 'title', 'description')

      chapter = result['chapter_details'].first
      expect(chapter).to include('position', 'translations')
      expect(chapter['translations'].first).to include('language', 'title', 'content')
    end
  end
end
