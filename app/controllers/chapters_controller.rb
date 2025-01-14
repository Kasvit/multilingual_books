# frozen_string_literal: true

class ChaptersController < ApplicationController
  before_action :set_book
  before_action :set_chapter

  def show
    @prev_chapter = @book.chapters.where('position < ?', @chapter.position).first
    @next_chapter = @book.chapters.where('position > ?', @chapter.position).order(position: :asc).last
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_chapter
    @chapter = @book.chapters.find_by(position: params[:position])
    raise ActiveRecord::RecordNotFound unless @chapter
  end
end
