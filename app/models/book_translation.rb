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

  # broadcasts_to ->(translation) { "admin_book_#{translation.book_id}_translations_#{translation.id}" },
  #               inserts_by: :prepend
  # after_create_commit -> {
  #   broadcast_prepend_to(
  #     "admin_book_#{book_id}_translations",
  #     target: "book_translations",
  #     partial: "admin/book_translations/book_translation",
  #     locals: { book: book, translation: self }
  #   )
  # }
  # after_update_commit -> {
  #   broadcast_replace_to(
  #     "admin_book_#{book_id}_translations",
  #     target: "book_translation_#{id}",
  #     partial: "admin/book_translations/book_translation"
  #   )
  # }
  # after_destroy_commit -> {
  #   broadcast_remove_to("admin_book_#{book_id}_translations", target: "book_translation_#{id}")
  # }

  # pg_search_scope :search_by_title,
  #                 against: :title,
  #                 using: {
  #                   tsearch: {
  #                     dictionary: "simple"
  #                   }
  #                 }
end
