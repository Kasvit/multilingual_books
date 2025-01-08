# frozen_string_literal: true

module Ai
  class TranslationService < Ai::BaseService
    CHUNK_SIZE = 1000
    SUPPORTED_LANGUAGES = %i[uk ru en ja ko zh].freeze

    def initialize(text, original_language, target_language)
      super()
      @text = text
      @original_language = original_language
      @target_language = target_language
      validate_language!
    end

    def translate
      puts "Translating text of length #{@text.length}"
      if @text.length > CHUNK_SIZE
        translate_large_text
      else
        translate_chunk(@text)
      end
    rescue OpenAI::Error, Faraday::TimeoutError => e
      handle_error(e)
    end

    private

    def translate_large_text
      chunks = split_into_chunks(@text)
      translate_chunk(chunks.first)
      # translated_chunks = chunks.map { |chunk| translate_chunk(chunk) }
      # translated_chunks.join("\n")
    end

    def translate_chunk(text)
      puts system_prompt
      response = @client.chat(
        parameters: {
          model: 'gpt-4o-mini',
          messages: build_messages(text),
          temperature: 0.3,
          presence_penalty: 0.0,
          frequency_penalty: 0.0
        }
      )

      content = response.dig('choices', 0, 'message', 'content')
      raise Ai::TranslationError, 'No translation received from OpenAI' if content.nil?

      # Перевіряємо наявність рядка з memory_key
      unless content.include?("Retrieve entities by memory_key: '#{memory_key}'")
        content += "\nRetrieve entities by memory_key: '#{memory_key}'"
      end

      content
    end

    def build_messages(text)
      [
        {
          role: 'system',
          content: system_prompt
        },
        {
          role: 'user',
          content: text
        }
      ]
    end

    def system_prompt
      <<~PROMPT
        You are a professional translator. Follow these rules strictly:
        1. Translate the following text from #{@original_language} to #{@target_language}.
        2. Preserve all formatting, line breaks, and special characters.
        3. Translate names according to the target language, unless explicitly requested to leave them in their original form. Maintain all name variations in memory with their corresponding languages.
        4. Maintain the original style and tone.
        5. Do not add any explanations or notes.
        6. Do not modify or remove any HTML tags if present. If present, check if they are valid and if they are not, fix them. If they don't have any text, remove them.
        7. While translating, refer to stored entities under the memory key "#{memory_key}". Ensure the translated text uses the correct names and attributes for entities that have already been stored, including their variations for the target language.
        8. Create a list of entities present in the text. Each record should contain the following fields in JSON format:
            - `type`: The type of the entity (e.g., character, location, concept, etc.).
            - `name`: A dictionary with keys as language codes (e.g., "en", "uk") and values as the name in the corresponding language.
            - `description`: A brief explanation of the entity.
            - `attributes`: Flexible attributes describing the entity (e.g., role, power level, age, characteristics, etc.).
        9. Save entities to the memory under the key "#{memory_key}". Ensure existing entities under this key are updated (if present), and new ones are appended.
        10. IMPORTANT: You must end your response with exactly this line (including single quotes):
            Retrieve entities by memory_key: '#{memory_key}'

        Remember: The last line of your response MUST be the memory key line specified above.
      PROMPT
    end

    def memory_key
      @memory_key ||= "translation_service:#{Time.now.to_i.to_s + @original_language.to_s + @target_language.to_s}"
    end

    def split_into_chunks(text)
      text.scan(/.{1,#{CHUNK_SIZE}}/m)
    end

    def validate_language!
      return if SUPPORTED_LANGUAGES.include?(@target_language) && SUPPORTED_LANGUAGES.include?(@original_language)

      raise ArgumentError, "Unsupported language. Supported languages: #{SUPPORTED_LANGUAGES.join(', ')}"
    end
  end
end
