# frozen_string_literal: true

module Ai
  class Error < StandardError; end
  class TranslationError < Error; end
  class RetrievalError < Error; end
end
