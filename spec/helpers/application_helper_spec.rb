# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#current_namespace?' do
    it 'returns true for matching namespace' do
      allow(helper).to receive(:request).and_return(double(path: '/test_namespace'))
      expect(helper.current_namespace?('test_namespace')).to be true
    end

    it 'returns false for non-matching namespace' do
      allow(helper).to receive(:request).and_return(double(path: '/other_namespace'))
      expect(helper.current_namespace?('test_namespace')).to be false
    end
  end

  describe '#open_modal' do
    it 'renders the modal with the correct title, content, and footer' do
      title = 'Test Title'
      content = 'Test Content'
      footer = 'Test Footer'
      expect(helper).to receive(:turbo_stream).and_return(double(replace: true))
      expect(helper.open_modal(title, content, footer)).to be_truthy
    end
  end

  describe '#close_modal' do
    it 'renders the modal as closed' do
      expect(helper).to receive(:turbo_stream).and_return(double(replace: true))
      expect(helper.close_modal).to be_truthy
    end
  end
end
