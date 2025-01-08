# frozen_string_literal: true

require 'database_cleaner/active_record'
require 'database_cleaner/redis'

RSpec.configure do |config|
  config.before(:suite) do
    # Очищення PostgreSQL
    DatabaseCleaner[:active_record].clean_with(:truncation)
    DatabaseCleaner[:active_record].strategy = :transaction

    # Очищення Redis
    DatabaseCleaner[:redis].clean_with(:deletion)
    DatabaseCleaner[:redis].strategy = :deletion
  end

  config.around(:each) do |example|
    DatabaseCleaner[:active_record].cleaning do
      DatabaseCleaner[:redis].cleaning do
        example.run
      end
    end
  end
end
