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
FactoryBot.define do
  factory :chapter do
    title { Faker::Book.title }
    content { Faker::Lorem.paragraph(sentence_count: 3) }
    published { false }
    association :book
    position { 1 }

    trait :published do
      published { true }
    end
  end
end
