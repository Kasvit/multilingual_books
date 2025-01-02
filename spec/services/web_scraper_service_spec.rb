require 'rails_helper'

RSpec.describe WebScraperService do
  describe '#select_parser' do
    subject { described_class.new(url).send(:select_parser, url) }

    context 'when URL is from ranoberf' do
      let(:url) { 'https://xn--80ac9aeh6f.xn--p1ai/chapter/123' }

      it 'returns RanoberfParser instance' do
        expect(subject).to be_an_instance_of(Parsers::RanoberfParser)
      end
    end

    context 'when URL is from tirulate' do
      let(:url) { 'https://tl.rulate.ru/chapter/123' }

      it 'returns TirulateParser instance' do
        expect(subject).to be_an_instance_of(Parsers::TirulateParser)
      end
    end

    context 'when URL is unknown' do
      let(:url) { 'https://example.com/chapter/123' }

      it 'returns BaseParser instance' do
        expect(subject).to be_an_instance_of(Parsers::BaseParser)
      end
    end
  end
end
