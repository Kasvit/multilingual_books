# README

App for translating books to multiple languages.

### TODO:
- [ ] Add book model with one language
- [ ] Add book chapters model with one language (delegated from the book)
- [ ] Add to book on UI available languages
- [ ] Add chapter autoincrement position
- [ ] Add users, authentication. Admin, translator, user
- [ ] Add to user primary language, secondary languages
- [ ] Add react
- [ ] Add react chapters page
- [ ] Add to chapter on UI available languages
- [ ] Add dark/light mode
- [ ] Add to book: hidden, hidden_reason (publisher can send a reason), published (when the description is ready. allow to send to sitemap)
- [ ] Add to chapter: statuses: hidden?, ready_to_show, translating
- [ ] Add notifications: a new chapter from the following book, new comments
- [ ] Add AI chapter translator (https://github.com/wikiti/deepl-rb)  (mark to translated with AI)


#### Additional:
- use https://github.com/galetahub/ckeditor or similar
- [ ] Add to book statuses: translated, ongoing, frozen, dropped
- [ ] Add UI user custom settings
- [ ] Translator can send a request for a chapter translation (see below)
- [ ] Chapters can be paid. Chapters can become free after some time (set by admin/translator)
- [ ] Add user statistics: what books he read, what chapters he read
- [ ] Add chapters and book description detectors to review text for harmful content (AI?)
- [ ] Add website parser
- [ ] Add to book: author, publisher, tags, genre, main image, gallery images, rating, comments with commentable
- [ ] Comments can be commented
- [ ] Genres can be used for filtering books
- [ ] Add to book: 'download book' button (generate epub or pdf and open in browser or send to email) (paid)
- [ ] Add to book: 'buy book' button and buy all chapters??
- [ ] Migrate to AWS


### Example of usage
- Адмін або перекладач створює нову книгу з назвою і описом певною мовою
- Адмін може запустити ріквест, щоб перекласти назву і опис книги на вибрані мови
- Адмін додає до книги розділи з певною мовою
- Адмін може запустити ріквест, щоб перекласти розділ на вибрані мови
- Користувачі можуть переглядати книги і розділи з певною мовою

#### Translators:
- [ ] Add translators and paid chapters only when I find somebody to help manage it
- [ ] Add translator's UI (new layout?)
- книжка має перекладачів. Перекладачі можуть надіслати ріквест щоб їх додати до кнгии
- якщо перекладач доданий до книги, то він може додавати нові розділи до книги з привязкою до цого розділу
- у книжки є тільки одна мова і у її розділів також
- можуть бути інші записи в БД по цій книжці на іншій мові.
