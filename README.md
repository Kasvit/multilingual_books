# README

App for translating books to multiple languages.

### TODO:
- [ ] Add book model
- [ ] Add book chapters model
- [ ] Add websites parser
- [ ] Add ai book translator
- [ ] Add UI
- [ ] Add dark/light mode
- [ ] Add users
- [ ] Add authentication
- [ ] Add UI user custom settings


scraper = WebScraperService.new('https://tl.rulate.ru/book/7481/166707/ready_new')
text = scraper.fetch_and_parse

translation_service = Ai::TranslationService.new(text, :ru, :uk)
result = translation_service.translate

entities_retrieval_service = Ai::EntitiesRetrievalService.new(result[:memory_key])
entities = entities_retrieval_service.retrieve

puts result
puts entities

### How to:
- check how to use https://github.com/wikiti/deepl-rb
- check how to create books with multiple languages
- same for chapters



### Example of usage
- Адмін створює нову книгу з назвою і описом певною мовою
- Адмін може запустити ріквест, щоб перекласти назву і опис книги на вибрані мови
- Адмін додає до книги розділи з певною мовою
- Адмін може запустити ріквест, щоб перекласти розділ на вибрані мови
- Користувачі можуть переглядати книги і розділи з певною мовою



### Additional:
- use https://github.com/galetahub/ckeditor or similar
- у книги і розділів є поле, ready_to_publish, яке показує, що книга готова до публікації
- у книги є автор опционально
- у книги є видавець опционально
- у книги є теги опционально
- у книги є жанр опционально
- у книги є картинка, група картинок  опционально
- у книги є рейтинг
- коментарі до книги і розділів
