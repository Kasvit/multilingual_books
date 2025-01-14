# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlashMessage::Component, type: :component do
  subject { render_inline(described_class.new(type: type, message: message)) }

  let(:message) { 'This is a flash message' }

  describe 'success type' do
    let(:type) { :success }

    it 'renders the message with success classes' do
      subject
      expect(page).to have_content(message)
      expect(page).to have_css('.bg-green-100.border-green-400.text-green-700')
    end
  end

  describe 'error type' do
    let(:type) { :error }

    it 'renders the message with error classes' do
      subject
      expect(page).to have_content(message)
      expect(page).to have_css('.bg-red-100.border-red-400.text-red-700')
    end
  end

  describe 'warning type' do
    let(:type) { :warning }

    it 'renders the message with warning classes' do
      subject
      expect(page).to have_content(message)
      expect(page).to have_css('.bg-yellow-100.border-yellow-400.text-yellow-700')
    end
  end

  describe 'notice type' do
    let(:type) { :notice }

    it 'renders the message with notice classes' do
      subject
      expect(page).to have_content(message)
      expect(page).to have_css('.bg-blue-100.border-blue-400.text-blue-700')
    end
  end

  describe 'default type' do
    let(:type) { :other }

    it 'renders the message with default classes' do
      subject
      expect(page).to have_content(message)
      expect(page).to have_css('.bg-gray-100.border-gray-400.text-gray-700')
    end
  end

  describe 'without a message' do
    let(:type) { :success }
    let(:message) { nil }

    it 'does not raise an error' do
      expect { subject }.not_to raise_error
    end

    it 'does not render the component' do
      subject
      expect(page).to have_no_css('.bg-green-100.border-green-400.text-green-700')
      expect(page).not_to have_content('This is a flash message')
    end
  end
end
