# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @books = Book.includes(:book_translations).all
  end

  def show
    @book = Book.includes(:book_translations, chapters: [:chapter_translations])
                .references(:chapters)
                .where(id: params[:id])
                .order('chapters.position ASC')
                .first!
  end
end
