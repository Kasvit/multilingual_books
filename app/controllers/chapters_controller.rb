# frozen_string_literal: true

class ChaptersController < ApplicationController
  before_action :set_book
  before_action :set_chapter

  def show
    @prev_chapter = @book.chapters.where('position < ?', @chapter.position)
                         .order(position: :desc).first
    @next_chapter = @book.chapters.where('position > ?', @chapter.position)
                         .order(:position).first
  end

  private

  def set_book
    @book = Book.includes(:book_translations).find(params[:book_id])
  end

  def set_chapter
    @chapter = @book.chapters.includes(:chapter_translations)
                    .find_by!(position: params[:position])
  end
end
