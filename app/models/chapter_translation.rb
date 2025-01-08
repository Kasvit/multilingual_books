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
class ChapterTranslation < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :chapter

  validates :language, presence: true
  validates :title, presence: true
  validates :language, uniqueness: { scope: :chapter_id }

  # broadcasts_to ->(translation) { "admin_chapter_#{translation.chapter_id}_translations_#{translation.id}" },
  #               inserts_by: :prepend
end
