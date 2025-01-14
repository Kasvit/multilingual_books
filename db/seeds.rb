# frozen_string_literal: true

# # frozen_string_literal: true

# Clean database
Book.destroy_all
Chapter.destroy_all

book1 = Book.create(language: :en, title: 'The Great Gatsby')
book1_uk = book1.translations.create(language: :uk, title: 'Великий Гетсбі')

book2 = Book.create(language: :en, title: '1984')
book2_uk = book2.translations.create(language: :uk, title: '1984')

book3 = Book.create(language: :en, title: 'To Kill a Mockingbird')
book3_uk = book3.translations.create(language: :uk, title: 'Вбити пересмішника')

book1.chapters.create(title: 'Chapter 1', content: 'In my younger and more vulnerable years...', position: 1)
book1_uk.chapters.create(title: 'Розділ 1', content: 'У мої молодші та вразливіші роки...', position: 1)

book1.chapters.create(title: 'Chapter 2', content: 'About half past nine the motor boat gave a sharp twist...',
                      position: 2)
book1_uk.chapters.create(title: 'Розділ 2', content: 'Приблизно о пів на десяту моторний човен різко повернув...',
                         position: 2)

book2.chapters.create(title: 'Chapter 1',
                      content: 'It was a bright cold day in April, and the clocks were striking thirteen.', position: 1)
book2_uk.chapters.create(title: 'Розділ 1',
                         content: 'Це був яскравий холодний день в квітні, і годинники били тринадцять.', position: 1)

book2.chapters.create(title: 'Chapter 2', content: 'As soon as he found himself in the street, Winston turned left...',
                      position: 2)
book2_uk.chapters.create(title: 'Розділ 2', content: 'Як тільки він опинився на вулиці, Вінстон повернув наліво...',
                         position: 2)

book3.chapters.create(title: 'Chapter 1',
                      content: 'When he was nearly thirteen, my brother Jem got his arm badly broken at the elbow.', position: 1)
book3_uk.chapters.create(title: 'Розділ 1',
                         content: 'Коли йому було майже тринадцять, мій брат Джем сильно зламав руку в лікті.', position: 1)

book3.chapters.create(title: 'Chapter 2', content: 'Dill was a curiosity.', position: 2)
book3_uk.chapters.create(title: 'Розділ 2', content: 'Ділл був цікавинкою.', position: 2)

puts "\nSeeding completed!"
puts 'Created:'
puts "- #{Book.count} books"
puts "- #{Chapter.count} chapters"
