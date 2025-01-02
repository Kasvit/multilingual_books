class AiTranslationService
  CHUNK_SIZE = 4000
  SUPPORTED_LANGUAGES = %w[
    Ukrainian English Spanish French German Italian Portuguese Russian
    Chinese Japanese Korean Arabic Hindi Turkish Polish
  ].freeze

  def initialize(text, target_language)
    @text = text
    @target_language = target_language
    validate_language!
    @client = OpenAI::Client.new
  end

  def translate
    if @text.length > CHUNK_SIZE
      translate_large_text
    else
      translate_chunk(@text)
    end
  rescue OpenAI::Error => e
    handle_error(e)
  end

  private

  def translate_large_text
    chunks = split_into_chunks(@text)
    translated_chunks = chunks.map { |chunk| translate_chunk(chunk) }
    translated_chunks.join("\n")
  end

  def translate_chunk(text)
    response = @client.chat(
      parameters: {
        model: "gpt-4o",
        messages: build_messages(text),
        temperature: 0.3,
        presence_penalty: 0.0,
        frequency_penalty: 0.0
      }
    )

    response.dig("choices", 0, "message", "content") ||
      raise(TranslationError, "No translation received from OpenAI")
  end

  def build_messages(text)
    [
      {
        role: "system",
        content: system_prompt
      },
      {
        role: "user",
        content: text
      }
    ]
  end

  def system_prompt
    <<~PROMPT
      You are a professional translator. Follow these rules strictly:
      1. Translate the following text to #{@target_language}
      2. Preserve all formatting, line breaks, and special characters
      3. Keep names in their original form
      4. Maintain the original style and tone
      5. Do not add any explanations or notes
      6. Do not modify or remove any HTML tags if present
    PROMPT
  end

  def split_into_chunks(text)
    text.scan(/.{1,#{CHUNK_SIZE}}/m)
  end

  def validate_language!
    unless SUPPORTED_LANGUAGES.include?(@target_language)
      raise ArgumentError, "Unsupported target language: #{@target_language}. " \
                          "Supported languages: #{SUPPORTED_LANGUAGES.join(', ')}"
    end
  end

  def handle_error(error)
    case error
    when OpenAI::Error
      raise TranslationError, "OpenAI API error: #{error.message}"
    else
      raise TranslationError, "Translation failed: #{error.message}"
    end
  end
end

class TranslationError < StandardError; end
