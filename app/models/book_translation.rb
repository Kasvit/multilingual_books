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
class BookTranslation < ApplicationRecord
  # include PgSearch::Model

  default_scope { order(created_at: :desc) }

  belongs_to :book

  validates :language, presence: true
  validates :title, presence: true
  validates :language, uniqueness: { scope: :book_id }

  broadcasts_to ->(translation) { "book_#{translation.book_id}_translations" },
                inserts_by: :prepend

  # pg_search_scope :search_by_title,
  #                 against: :title,
  #                 using: {
  #                   tsearch: {
  #                     dictionary: "simple"
  #                   }
  #                 }
end
