# frozen_string_literal: true

module Admin
  class BookTranslationsController < AdminController
    before_action :set_book
    before_action :set_translation, only: %i[edit update destroy]

    def new
      @translation = @book.book_translations.build(language: params[:language])
    end

    def create
      @translation = @book.book_translations.build(translation_params)

      respond_to do |format|
        if @translation.save
          format.html { redirect_to admin_book_path(@book), notice: 'Translation was successfully added.' }
          format.turbo_stream do
            flash.now[:notice] = 'Translation was successfully added.'
            render turbo_stream: [
              turbo_stream.replace('book_translations', partial: 'admin/books/translations', locals: { book: @book }),
              turbo_stream.remove('modal'),
              turbo_stream.append('flash', partial: 'shared/flash', locals: { flash: flash })
            ]
          end
        else
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream { render :form_update, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @translation.destroy

      respond_to do |format|
        format.html { redirect_to admin_book_path(@book), notice: 'Translation was successfully removed.' }
        format.turbo_stream do
          flash.now[:notice] = 'Translation was successfully removed.'
          render turbo_stream: [
            turbo_stream.replace('book_translations', partial: 'admin/books/translations', locals: { book: @book }),
            turbo_stream.append('flash', partial: 'shared/flash', locals: { flash: flash })
          ]
        end
      end
    end

    def edit; end

    def update
      respond_to do |format|
        if @translation.update(translation_params)
          format.html { redirect_to admin_book_path(@book), notice: 'Translation was successfully updated.' }
          format.turbo_stream do
            flash.now[:notice] = 'Translation was successfully updated.'
            render turbo_stream: [
              turbo_stream.replace("book_#{@book.id}", partial: 'admin/books/book', locals: { book: @book }),
              turbo_stream.remove('modal'),
              turbo_stream.append('flash', partial: 'shared/flash', locals: { flash: flash })
            ]
          end
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render :form_update, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_book
      @book = Book.find(params[:book_id])
    end

    def set_translation
      @translation = @book.book_translations.find_by!(language: params[:id])
    end

    def translation_params
      params.require(:book_translation).permit(:title, :description, :language)
    end
  end
end
