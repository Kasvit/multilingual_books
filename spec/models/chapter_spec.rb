# frozen_string_literal: true

# == Schema Information
#
# Table name: chapters
#
#  id         :bigint           not null, primary key
#  content    :string
#  position   :integer          not null
#  published  :boolean          default(FALSE), not null
#  title      :string           not null
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
  subject { build(:chapter) }

  # Validations
  it { is_expected.to validate_presence_of(:title) }
  xit { is_expected.to validate_presence_of(:position) }
  xit { is_expected.to validate_uniqueness_of(:position).scoped_to(:book_id) }
  xit { is_expected.to validate_numericality_of(:position).is_greater_than(0) }

  # Associations
  it { is_expected.to belong_to(:book) }

  # Callbacks
  describe 'callbacks' do
    context 'before validation' do
      it 'sets the position before creating a chapter' do
        book = create(:book)
        chapter = build(:chapter, book: book)
        chapter.save
        expect(chapter.position).to eq(1) # First chapter should have position 1

        second_chapter = create(:chapter, book: book)
        expect(second_chapter.position).to eq(2) # Second chapter should have position 2
      end
    end
  end

  # Instance methods
  describe '#to_param' do
    it 'returns the position as a string' do
      chapter = build(:chapter, position: 5)
      expect(chapter.to_param).to eq('5')
    end
  end
end
