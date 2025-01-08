# frozen_string_literal: true

# == Schema Information
#
# Table name: chapter_translations
#
#  id         :bigint           not null, primary key
#  content    :text
#  language   :string           not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chapter_id :bigint           not null
#
# Indexes
#
#  index_chapter_translations_on_chapter_id               (chapter_id)
#  index_chapter_translations_on_chapter_id_and_language  (chapter_id,language) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (chapter_id => chapters.id)
#
require 'rails_helper'

RSpec.describe ChapterTranslation, type: :model do
  describe 'associations' do
    it { should belong_to(:chapter) }
  end

  describe 'validations' do
    subject { build(:chapter_translation) }

    it { should validate_presence_of(:language) }
    it { should validate_presence_of(:title) }

    describe 'uniqueness' do
      let(:book) { create(:book) }
      let(:chapter) { create(:chapter, book: book, position: book.chapters.maximum(:position).to_i + 1) }
      subject { build(:chapter_translation, chapter: chapter, language: 'ja') }

      it { should validate_uniqueness_of(:language).scoped_to(:chapter_id) }
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:chapter_translation)).to be_valid
    end

    it 'has valid language-specific traits' do
      expect(build(:chapter_translation, :ukrainian)).to be_valid
      expect(build(:chapter_translation, :russian)).to be_valid
      expect(build(:chapter_translation, :english)).to be_valid
    end
  end
end
