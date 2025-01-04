module Ai
  class BaseService
    DEFAULT_TIMEOUT = 600 # 10 minutes

    def initialize
      @client = OpenAI::Client.new(
        request_timeout: DEFAULT_TIMEOUT,
        read_timeout: DEFAULT_TIMEOUT
      )
    end

    private

    def handle_error(error)
      case error
      when OpenAI::Error
        raise Ai::Error, "OpenAI API error: #{error.message}"
      when Faraday::TimeoutError
        raise Ai::Error, "Request timeout. The operation took too long to complete."
      else
        raise Ai::Error, "Service failed: #{error.message}"
      end
    end
  end
end 