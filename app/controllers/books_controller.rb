# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @books = Book.includes(:translations, :original_book).all
  end

  def show
    @book = Book.includes(:translations, :chapters)
                .references(:chapters, :translations)
                .where(id: params[:id])
                .order('chapters.position ASC')
                .first!
  end
end
