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
    title { Faker::Book.title }
    description { Faker::Lorem.sentence(word_count: 10) }
    language { %w[en uk ru ja ko zh].sample }
    published { false }
    hidden { false }
    hidden_reason { nil }
    original_book_id { nil }

    trait :published do
      published { true }
    end

    trait :with_translation do
      after(:create) do |book|
        create(:book, original_book: book, language: book.available_languages.sample, title: Faker::Book.title)
      end
    end

    trait :with_chapter do
      after(:create) do |book|
        create(:chapter, book: book, title: Faker::Book.title, content: Faker::Lorem.paragraph)
      end
    end
  end
end
