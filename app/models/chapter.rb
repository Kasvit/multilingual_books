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
class Chapter < ApplicationRecord
  default_scope { order(position: :desc) }

  belongs_to :book

  validates :position, presence: true
  validates :position, uniqueness: { scope: :book_id }
  validates :position, numericality: { greater_than: 0 }
  validates :title, presence: true

  before_validation :set_position, on: :create

  def to_param
    position.to_s
  end

  private

  def set_position
    max_position = Chapter.where(book_id: book_id).maximum(:position) || 0
    self.position = max_position + 1
  end
end
