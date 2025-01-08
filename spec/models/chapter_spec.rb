# frozen_string_literal: true

# == Schema Information
#
# Table name: chapters
#
#  id         :bigint           not null, primary key
#  position   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint           not null
#
# Indexes
#
#  index_chapters_on_book_id               (book_id)
#  index_chapters_on_book_id_and_position  (book_id,position) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#
require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe 'associations' do
    it { should belong_to(:book) }
    it { should have_many(:chapter_translations).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:position) }
  end

  describe 'callbacks' do
    describe 'after_create' do
      let(:book) { create(:book) }

      it 'generates translations for all selected languages' do
        chapter = create(:chapter, book: book)
        expect(chapter.position).to eq(2) # Нова глава повинна мати position = 2
        expect(chapter.chapter_translations.count).to eq(book.selected_languages.count)
        expect(chapter.chapter_translations.pluck(:language)).to match_array(book.selected_languages)
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:chapter)).to be_valid
    end

    it 'creates translations automatically' do
      book = create(:book)
      chapter = create(:chapter, book: book)
      expect(chapter.position).to eq(2) # Має бути 2, бо перша глава вже створена
      expect(chapter.chapter_translations.count).to eq(3) # uk, ru, en
    end
  end
end
