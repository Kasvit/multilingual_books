# frozen_string_literal: true

# == Schema Information
#
# Table name: book_translations
#
#  id          :bigint           not null, primary key
#  description :text
#  language    :string           not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  book_id     :bigint           not null
#
# Indexes
#
#  book_translations_title_tsvector_idx             (to_tsvector('simple'::regconfig, (title)::text)) USING gin
#  index_book_translations_on_book_id               (book_id)
#  index_book_translations_on_book_id_and_language  (book_id,language) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#
require 'rails_helper'

RSpec.describe BookTranslation, type: :model do
  describe 'associations' do
    it { should belong_to(:book) }
  end

  describe 'validations' do
    subject { build(:book_translation) }

    it { should validate_presence_of(:language) }
    it { should validate_presence_of(:title) }

    describe 'uniqueness' do
      subject { build(:book_translation, language: 'ja') } # Використовуємо мову, яка не створюється автоматично

      it { should validate_uniqueness_of(:language).scoped_to(:book_id) }
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:book_translation)).to be_valid
    end

    it 'has valid language-specific traits' do
      expect(build(:book_translation, :ukrainian)).to be_valid
      expect(build(:book_translation, :russian)).to be_valid
      expect(build(:book_translation, :english)).to be_valid
    end
  end
end
