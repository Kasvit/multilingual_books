require 'rails_helper'

RSpec.describe Parsers::BaseParser do
  let(:parser) { described_class.new('.test-selector') }

  describe '#fetch_and_parse' do
    let(:url) { 'https://example.com' }
    let(:html_content) do
      <<~HTML
        <html>
          <body>
            <div class="test-selector">Test content</div>
          </body>
        </html>
      HTML
    end

    before do
      allow(URI).to receive(:open).with(url).and_return(StringIO.new(html_content))
      allow(CharlockHolmes::EncodingDetector).to receive(:detect)
        .and_return({ encoding: 'UTF-8' })
    end

    it 'successfully parses content' do
      expect(parser.fetch_and_parse(url)).to include('Test content')
    end

    context 'when content is not found' do
      let(:html_content) { '<html><body></body></html>' }

      it 'raises an error' do
        expect { parser.fetch_and_parse(url) }
          .to raise_error('Parsing error: Content not found')
      end
    end

    context 'when URL is invalid' do
      before do
        allow(URI).to receive(:open).and_raise(OpenURI::HTTPError.new('404', nil))
      end

      it 'raises a parsing error' do
        expect { parser.fetch_and_parse(url) }
          .to raise_error(/Parsing error: 404/)
      end
    end
  end
end
