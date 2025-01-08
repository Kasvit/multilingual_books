# frozen_string_literal: true

require 'faker'

def generate_chapter_content
  paragraphs = (3..7).to_a.sample.times.map do
    Faker::Lorem.paragraph(sentence_count: 10, supplemental: true, random_sentences_to_add: 4)
  end
  paragraphs.join("\n\n")
end

puts 'Cleaning database...'
ChapterTranslation.destroy_all
Chapter.destroy_all
BookTranslation.destroy_all
Book.destroy_all

puts 'Creating books...'
books_data = [
  {
    isbn: '978-0-7475-3269-9',
    chapters_count: 5,
    translations: {
      uk: { title: 'Шлях Дракона', description: 'Український опис книги' },
      en: { title: "The Dragon's Path", description: 'English book description' },
      ru: { title: 'Путь Дракона', description: 'Описание книги на русском' }
    }
  },
  {
    isbn: '978-0-7475-3270-5',
    chapters_count: 3,
    translations: {
      uk: { title: 'Містичні казки', description: 'Український опис книги' },
      en: { title: 'Mystic Tales', description: 'English book description' },
      ru: { title: 'Мистические сказки', description: 'Описание книги на русском' }
    }
  }
]

books_data.each do |book_data|
  puts "Creating book with ISBN: #{book_data[:isbn]}"
  book = Book.find_or_create_by!(isbn: book_data[:isbn])

  book_data[:translations].each do |language, translation_data|
    translation = book.book_translations.find_by(language: language)
    translation.update!(
      title: translation_data[:title],
      description: translation_data[:description]
    )
  end

  book_data[:chapters_count].times do |i|
    position = i + 1
    puts "  Creating chapter #{position}"
    chapter = book.chapters.find_or_create_by!(position: position)

    Book::AVAILABLE_LANGUAGES.each do |language|
      translation = chapter.chapter_translations.find_by(language: language)
      content = generate_chapter_content
      translation_data = book_data[:translations][language.to_sym]

      translation.update!(
        title: "#{translation_data[:title]} - Розділ #{position}",
        content: content
      )
    end
  end
end

puts "\nSeeding completed!"
puts 'Created:'
puts "- #{Book.count} books"
puts "- #{BookTranslation.count} book translations"
puts "- #{Chapter.count} chapters"
puts "- #{ChapterTranslation.count} chapter translations"
