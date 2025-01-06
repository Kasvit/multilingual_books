# frozen_string_literal: true

SimpleCov.start 'rails' do
  # Форматування результатів
  formatter SimpleCov::Formatter::MultiFormatter.new([
                                                       SimpleCov::Formatter::HTMLFormatter,
                                                       SimpleCov::Formatter::SimpleFormatter
                                                     ])

  # Merge результатів з різних процесів тестів
  use_merging true
  merge_timeout 3600

  # Додаткові налаштування
  track_files 'app/**/*.rb'

  # Ігноруємо певні паттерни
  add_filter do |source_file|
    source_file.lines.count < 5
  end

  # Додаємо власні групи
  add_group 'Long files' do |source_file|
    source_file.lines.count > 100
  end

  # Налаштування для CI
  if ENV['CI']
    formatter SimpleCov::Formatter::SimpleFormatter
    minimum_coverage 90
    refuse_coverage_drop
  end
end
