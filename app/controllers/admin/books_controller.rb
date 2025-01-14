# frozen_string_literal: true

module Admin
  class BooksController < AdminController
    before_action :set_book, only: %i[show edit update destroy new_translation create_translation]

    def index
      @books = Book.originals.includes(:translations).all
    end

    def show; end

    def new
      @book = Book.new
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_to admin_books_path
        end
      end
    end

    def create
      @book = Book.new(book_params)

      respond_to do |format|
        if @book.save
          format.turbo_stream { flash.now[:notice] = 'Book was successfully created.' }
        else
          format.turbo_stream { render :new, status: :unprocessable_entity }
        end
      end
    end

    def edit
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_to admin_book_path(@book)
        end
      end
    end

    def update
      respond_to do |format|
        if @book.update(book_params)
          format.turbo_stream { flash.now[:notice] = 'Book was successfully updated.' }
        else
          format.turbo_stream { render :update, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @book.destroy

      respond_to do |format|
        format.html { redirect_to admin_books_path, notice: 'Book was successfully destroyed.' }
        format.turbo_stream { flash.now[:notice] = 'Book was successfully destroyed.' }
      end
    end

    def new_translation
      @translation = @book.translations.build
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_to admin_books_path
        end
      end
    end

    def create_translation
      @translation = @book.translations.build(book_params)
      respond_to do |format|
        if @translation.save
          format.turbo_stream { flash.now[:notice] = 'Translation was successfully created.' }
        else
          format.turbo_stream { render :new_translation, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_book
      @book = Book.includes(:translations, :chapters).find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :description, :language)
    end
  end
end
