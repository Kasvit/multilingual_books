# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @books = Book.includes(:translations).all
  end

  def show
    @book = Book.includes(:translations, :chapters)
                .references(:chapters)
                .where(id: params[:id])
                .order('chapters.position ASC')
                .first!
  end
end
