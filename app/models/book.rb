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
class Book < ApplicationRecord
  AVAILABLE_LANGUAGES = %w[uk ru en ja ko zh].freeze # Site.settings.languages

  default_scope { order(created_at: :desc) }

  has_many :chapters, dependent: :destroy
  has_many :translations, class_name: 'Book', foreign_key: 'original_book_id', dependent: :nullify
  belongs_to :original_book, class_name: 'Book', optional: true

  validates :title, presence: true, uniqueness: { scope: :language }
  validates :language, presence: true
  validates :language, uniqueness: { scope: :original_book_id, message: 'only one translated language per original book' }, if: lambda {
    original_book_id.present?
  }
  validate :language_cannot_be_same_as_original_book, if: -> { original_book_id.present? }

  scope :originals, -> { where(original_book_id: nil) }

  def available_languages
    return original_book.available_languages if original_book.present?

    excluded_languages = [language].compact
    excluded_languages += translations.pluck(:language).to_a
    AVAILABLE_LANGUAGES - excluded_languages
  end

  private

  def language_cannot_be_same_as_original_book
    return unless original_book && language == original_book.language

    errors.add(:language, "cannot be the same as the original book's language")
  end
end
