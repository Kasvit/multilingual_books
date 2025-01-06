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
FactoryBot.define do
  factory :chapter_translation do
    association :chapter
    language { %w[uk ru en].sample }
    title { Faker::Book.title }
    content { Faker::Lorem.paragraphs(number: 3).join("\n\n") }

    trait :ukrainian do
      language { 'uk' }
      title { "Розділ: #{Faker::Book.title}" }
    end

    trait :russian do
      language { 'ru' }
      title { "Глава: #{Faker::Book.title}" }
    end

    trait :english do
      language { 'en' }
      title { "Chapter: #{Faker::Book.title}" }
    end
  end
end
