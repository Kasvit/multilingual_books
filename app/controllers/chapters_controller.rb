# frozen_string_literal: true

class ChaptersController < ApplicationController
  before_action :set_book
  before_action :set_chapter

  def show
    @has_prev_chapter = @book.chapters.any? { |ch| ch.position == @chapter.position - 1 }
    @has_next_chapter = @book.chapters.any? { |ch| ch.position == @chapter.position + 1 }
  end

  private

  def set_book
    @book = Book.includes(:book_translations, chapters: :chapter_translations)
                .find(params[:book_id])
  end

  def set_chapter
    @chapter = @book.chapters.find { |ch| ch.position == params[:position].to_i }
    raise ActiveRecord::RecordNotFound unless @chapter
  end
end
