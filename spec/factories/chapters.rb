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
FactoryBot.define do
  factory :chapter do
    association :book

    # Використовуємо lambda для динамічного визначення position
    position do
      book.chapters.maximum(:position).to_i + 1
    end

    trait :with_translations do
      # Не потрібно створювати переклади вручну, вони створюються через after_create
    end
  end
end
