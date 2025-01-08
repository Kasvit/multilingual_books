# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebScraperService do
  let(:service) { described_class.new(url) }

  describe '#fetch_and_parse' do
    context 'when parsing ranoberf' do
      let(:url) { 'https://ранобэ.рф/some-chapter' }
      let(:html_content) do
        <<-HTML
          <html>
            <body>
              <div class="overflow-hidden text-base leading-5">
                Текст глави
              </div>
            </body>
          </html>
        HTML
      end

      before do
        allow(URI).to receive(:open).with(url).and_return(StringIO.new(html_content))
        allow(CharlockHolmes::EncodingDetector).to receive(:detect)
          .and_return({ encoding: 'UTF-8' })
      end

      it 'extracts content using correct selector' do
        expect(service.fetch_and_parse).to include('Текст глави')
      end
    end

    context 'when parsing tirulate' do
      let(:url) { 'https://tl.rulate.ru/some-chapter' }
      let(:html_content) do
        <<-HTML
          <html>
            <body>
              <div class="content-text">
                Текст глави
              </div>
            </body>
          </html>
        HTML
      end

      before do
        allow(URI).to receive(:open).with(url).and_return(StringIO.new(html_content))
        allow(CharlockHolmes::EncodingDetector).to receive(:detect)
          .and_return({ encoding: 'UTF-8' })
      end

      it 'extracts content using correct selector' do
        expect(service.fetch_and_parse).to include('Текст глави')
      end
    end

    context 'when content is not found' do
      let(:url) { 'https://example.com' }
      let(:html_content) { '<html><body></body></html>' }

      before do
        allow(URI).to receive(:open).with(url).and_return(StringIO.new(html_content))
        allow(CharlockHolmes::EncodingDetector).to receive(:detect)
          .and_return({ encoding: 'UTF-8' })
      end

      it 'raises an error' do
        expect { service.fetch_and_parse }.to raise_error('Parsing error: Content not found')
      end
    end

    context 'when encoding needs to be converted' do
      let(:url) { 'https://tl.rulate.ru/some-chapter' }
      let(:html_content) do
        content = <<-HTML
          <html>
            <body>
              <div class="content-text">
                Текст глави
              </div>
            </body>
          </html>
        HTML
        content.encode('Windows-1251')
      end

      before do
        allow(URI).to receive(:open).with(url).and_return(StringIO.new(html_content))
        allow(CharlockHolmes::EncodingDetector).to receive(:detect)
          .and_return({ encoding: 'Windows-1251' })
      end

      it 'correctly converts encoding and extracts content' do
        expect(service.fetch_and_parse).to include('Текст глави')
      end
    end

    context 'when network error occurs' do
      let(:url) { 'https://example.com' }

      before do
        allow(URI).to receive(:open).with(url).and_raise(OpenURI::HTTPError.new('404 Not Found', nil))
      end

      it 'raises a parsing error' do
        expect { service.fetch_and_parse }.to raise_error(/Parsing error:/)
      end
    end
  end
end
