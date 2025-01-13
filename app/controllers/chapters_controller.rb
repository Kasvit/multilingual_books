# frozen_string_literal: true

class ChaptersController < ApplicationController
  before_action :set_book
  before_action :set_chapter

  def show
    # TODO: find closest chapters instead of +- 1
    @has_prev_chapter = @book.chapters.any? { |ch| ch.position == @chapter.position - 1 }
    @has_next_chapter = @book.chapters.any? { |ch| ch.position == @chapter.position + 1 }
  end

  private

  def set_book
    @book = Book.includes(:translations, :chapters)
                .find(params[:book_id])
  end

  def set_chapter
    @chapter = @book.chapters.find_by(position: params[:position])
    raise ActiveRecord::RecordNotFound unless @chapter
  end
end
