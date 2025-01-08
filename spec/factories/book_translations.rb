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
FactoryBot.define do
  factory :book_translation do
    association :book
    language { %w[uk ru en].sample }
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph }

    trait :ukrainian do
      language { 'uk' }
      title { "Українська назва: #{Faker::Book.title}" }
    end

    trait :russian do
      language { 'ru' }
      title { "Русское название: #{Faker::Book.title}" }
    end

    trait :english do
      language { 'en' }
      title { "English title: #{Faker::Book.title}" }
    end
  end
end
