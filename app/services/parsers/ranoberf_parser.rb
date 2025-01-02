module Parsers
  class RanoberfParser < BaseParser
    CONTENT_SELECTOR = '.overflow-hidden.text-base.leading-5'.freeze

    def initialize
      super(CONTENT_SELECTOR)
    end

    def extract_content(doc)
      chapter_content = doc.at(CONTENT_SELECTOR) || doc.at('body')
      raise 'Ranoberf content not found' if chapter_content.nil? || chapter_content.inner_html.blank?

      decode_html_entities(chapter_content.inner_html)
    end
  end
end
