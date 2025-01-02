# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'uri'
require 'fileutils'

class WebScraper
  def self.get_body_content(url, include_tags: true)
    # Перевіряємо, чи URL коректний
    uri = URI.parse(url)
    raise 'Некоректний URL' unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

    begin
      # Завантажуємо сторінку
      doc = Nokogiri::HTML(URI.open(url))

      # Видаляємо всі script та style теги
      doc.css('script, style').each(&:remove)

      # Знаходимо div з художнім текстом
      content_div = doc.at('body')

      raise 'Контент не знайдено' unless content_div

      if include_tags
        # Повертаємо HTML контент зі збереженням тегів
        content_div.inner_html
      else
        # Повертаємо тільки текст
        content_div.text.strip
      end
    rescue OpenURI::HTTPError => e
      raise "Помилка HTTP: #{e.message}"
    rescue SocketError => e
      raise "Помилка мережі: #{e.message}"
    rescue StandardError => e
      raise "Виникла помилка: #{e.message}"
    end
  end

  def self.save_body_to_file(url, output_path = nil, include_tags: true)
    content = get_body_content(url, include_tags: include_tags)

    # Якщо шлях не вказано, створюємо файл на основі домену
    if output_path.nil?
      URI.parse(url).host.gsub('.', '_')
      timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
      # Змінюємо розширення на .html якщо зберігаємо з тегами
      extension = include_tags ? 'html' : 'txt'
      output_path = "output_#{timestamp}.#{extension}"
    end

    # Створюємо директорію, якщо вона не існує
    FileUtils.mkdir_p(File.dirname(output_path))

    # Зберігаємо контент у файл без додаткової HTML структури
    File.write(output_path, content)

    puts "Контент збережено у файл: #{output_path}"
    output_path
  end
end

# Приклад використання:
begin
  url = 'https://tl.rulate.ru/book/7481/166707/ready_new'

  # Зберегти з HTML тегами
  WebScraper.save_body_to_file(url, include_tags: true)

  # Зберегти тільки текст
  # text_file = WebScraper.save_body_to_file(url, include_tags: false)
rescue StandardError => e
  puts "Помилка: #{e.message}"
end
