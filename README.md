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
