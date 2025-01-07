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
class Chapter < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :book
  has_many :chapter_translations, dependent: :destroy

  after_create :generate_translations

  validates :position, presence: true

  delegate :selected_languages, to: :book

  broadcasts_to ->(chapter) { "books/#{chapter.book_id}/chapters" },
                inserts_by: :prepend

  def to_param
    position.to_s
  end

  private

  def generate_translations
    selected_languages.each do |language|
      translation = chapter_translations.find_or_create_by(language: language)
      translation.title ||= "Chapter title in #{language}"
      translation.save!
    end
  end
end
