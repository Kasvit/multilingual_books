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
  AVAILABLE_LANGUAGES = %w[uk ru en].freeze # Site.settings.languages

  default_scope { order(created_at: :desc) }

  has_many :chapters, dependent: :destroy
  has_many :translations, class_name: 'Book', foreign_key: 'original_book_id', dependent: :nullify
  belongs_to :original_book, class_name: 'Book', optional: true

  validates :title, presence: true, uniqueness: { scope: :language }
  validates :language, presence: true

  scope :originals, -> { where(original_book_id: nil) }
end
