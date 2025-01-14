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
  subject { build(:book) }

  # Validations
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:title).scoped_to(:language) }
  it { is_expected.to validate_presence_of(:language) }
  xit { is_expected.to validate_uniqueness_of(:language).scoped_to(:original_book_id).with_message('only one translated language per original book') }

  context 'when original_book_id is present' do
    let(:original_book) { create(:book, language: 'en', title: 'Unique Title') }

    it 'is valid with a unique language' do
      new_book = build(:book, original_book: original_book, language: 'ko', title: 'Another Unique Title')
      expect(new_book).to be_valid
    end

    it 'is not valid with the same language as the original book' do
      new_book = build(:book, original_book: original_book, language: 'en', title: 'Another Unique Title')
      expect(new_book).not_to be_valid
      expect(new_book.errors[:language]).to include("cannot be the same as the original book's language")
    end

    it 'is not valid with the same language as another translation' do
      create(:book, original_book: original_book, language: 'ko', title: 'Existing Translation Title')
      new_book = build(:book, original_book: original_book, language: 'ko', title: 'Another Unique Title')
      expect(new_book).not_to be_valid
      expect(new_book.errors[:language]).to include("only one translated language per original book")
    end
  end

  # Associations
  it { is_expected.to have_many(:chapters).dependent(:destroy) }
  it { is_expected.to have_many(:translations).class_name('Book').with_foreign_key('original_book_id').dependent(:nullify) }
  it { is_expected.to belong_to(:original_book).class_name('Book').optional }

  # Scopes
  describe '.originals' do
    it 'returns books without an original_book_id' do
      original_book = create(:book)
      translated_book = create(:book, original_book: original_book)

      expect(Book.originals).to include(original_book)
      expect(Book.originals).not_to include(translated_book)
    end
  end

  # Instance methods
  describe '#available_languages' do
    context 'when there is no original book' do
      it 'returns all available languages excluding the current book language' do
        book = create(:book, language: 'en')
        expect(book.available_languages).to include('uk', 'ru', 'ja', 'ko', 'zh')
        expect(book.available_languages).not_to include('en')
      end
    end

    context 'when there is an original book' do
      it 'returns available languages excluding the original book language and translations' do
        original_book = create(:book, language: 'en')
        book = create(:book, original_book: original_book, language: 'uk')
        create(:book, original_book: original_book, language: 'ko')

        expect(book.available_languages).to include('ru', 'ja', 'zh')
        expect(book.available_languages).not_to include('en', 'uk', 'ko')
      end
    end
  end
end
