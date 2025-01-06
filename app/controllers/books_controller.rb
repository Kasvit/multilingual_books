class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.includes(:book_translations).all
  end

  def show
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.turbo_stream {
          flash.now[:notice] = "Book was successfully created."
          render turbo_stream: [
            turbo_stream.append("books", partial: "book", locals: { book: @book }),
            turbo_stream.remove("modal"),
            turbo_stream.append("flash", partial: "shared/flash", locals: { flash: flash })
          ]
        }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.turbo_stream {
          flash.now[:notice] = "Book was successfully updated."
          render turbo_stream: [
            turbo_stream.replace(@book),
            turbo_stream.remove("modal"),
            turbo_stream.append("flash", partial: "shared/flash", locals: { flash: flash })
          ]
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Book was successfully destroyed." }
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:isbn, selected_languages: [])
  end
end
