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
FactoryBot.define do
  factory :book do
    isbn { Faker::Code.isbn }
    selected_languages { %w[uk ru en] }

    trait :with_chapters do
      after(:create) do |book|
        create_list(:chapter, 3, book: book)
      end
    end

    trait :full do
    end
  end
end
