# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                 :bigint           not null, primary key
#  isbn               :string
#  selected_languages :string           default([]), is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :book do
    isbn { Faker::Code.isbn }
    selected_languages { %w[uk ru en] }

    trait :with_translations do
      # Не потрібно створювати переклади вручну, вони створюються через after_create
    end

    trait :with_chapters do
      after(:create) do |book|
        # Не створюємо chapters через create_list, бо вони вже створюються через after_create
      end
    end

    trait :full do
      # Обидва колбеки спрацюють автоматично
    end
  end
end
