# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'factory_bot_rails'
require 'faker'
require 'shoulda-matchers'
require 'database_cleaner/active_record'
require 'simplecov'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

# Configure Faker to use specific locale
Faker::Config.locale = 'uk'

SimpleCov.start 'rails' do
  # Налаштування груп для звіту
  add_group 'Services', 'app/services'
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Mailers', 'app/mailers'

  # Ігноруємо певні файли/папки
  add_filter 'app/channels'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
  add_filter 'app/models/application_record.rb'

  # Мінімальний відсоток покриття
  minimum_coverage 90

  # Показувати файли з 0% покриття
  enable_coverage :branch

  # Зберігати результати в окремих папках для різних типів тестів
  coverage_dir 'coverage'
end
