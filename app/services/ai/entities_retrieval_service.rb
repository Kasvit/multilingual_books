module Ai
  class EntitiesRetrievalService < Ai::BaseService
    def initialize(memory_key)
      super()
      @memory_key = memory_key
    end

    def retrieve
      response = @client.chat(
        parameters: {
          model: "gpt-4",
          messages: build_messages,
          temperature: 0.1,
          presence_penalty: 0.0,
          frequency_penalty: 0.0
        }
      )

      parse_response(response)
    rescue OpenAI::Error => e
      handle_error(e)
    end

    private

    def build_messages
      [
        {
          role: "system",
          content: system_prompt
        },
        {
          role: "user",
          content: "Retrieve entities by #{@memory_key}"
        }
      ]
    end

    def system_prompt
      <<~PROMPT
        You are an AI assistant that retrieves stored entities. Follow these rules:
        1. Return only the entities stored under the specified memory key.
        2. Format the response as a valid JSON array of entities.
        3. Each entity should contain:
           - type
           - name (with language variations)
           - description
           - attributes
        4. Do not include any additional text or explanations.
        5. If no entities are found, return the full list of entities.
      PROMPT
    end

    def parse_response(response)
      content = response.dig("choices", 0, "message", "content")
      raise AI::RetrievalError, "No content received from OpenAI" if content.nil?

      JSON.parse(content)
    rescue JSON::ParserError => e
      raise AI::RetrievalError, "Failed to parse entities: #{e.message}"
    end
  end
end 