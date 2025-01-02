require 'rails_helper'

RSpec.describe Parsers::RanoberfParser do
  let(:parser) { described_class.new }

  describe '#extract_content' do
    let(:html_content) do
      <<~HTML
        <html>
          <body>
            <div class="overflow-hidden text-base leading-5">
              Novel content here
            </div>
          </body>
        </html>
      HTML
    end
    let(:doc) { Nokogiri::HTML(html_content) }

    it 'extracts content from correct selector' do
      expect(parser.extract_content(doc)).to include('Novel content here')
    end

    context 'when primary selector is not found' do
      let(:html_content) do
        <<~HTML
          <html>
            <body>
              Fallback content
            </body>
          </html>
        HTML
      end

      it 'falls back to body content' do
        expect(parser.extract_content(doc)).to include('Fallback content')
      end
    end

    context 'when no content is found' do
      let(:html_content) { '<html><body></body></html>' }
      let(:doc) { Nokogiri::HTML(html_content) }

      it 'raises an error' do
        expect { parser.extract_content(doc) }
          .to raise_error('Ranoberf content not found')
      end
    end
  end
end
