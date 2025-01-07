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
          format.turbo_stream { flash.now[:notice] = 'Translation was successfully added.' }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream { render :create, status: :unprocessable_entity }
        end
      end
    end

    def edit; end

    def update
      respond_to do |format|
        if @translation.update(translation_params)
          format.html { redirect_to admin_book_path(@book), notice: 'Translation was successfully updated.' }
          format.turbo_stream { flash.now[:notice] = 'Translation was successfully updated.' }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render :update, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @translation.destroy

      respond_to do |format|
        format.html { redirect_to admin_book_path(@book), notice: 'Translation was successfully removed.' }
        format.turbo_stream { flash.now[:notice] = 'Translation was successfully removed.' }
      end
    end

    private

    def set_book
      @book = Book.find(params[:book_id])
    end

    def set_translation
      @translation = @book.book_translations.find_by!(language: params[:language])
    end

    def translation_params
      params.require(:book_translation).permit(:title, :description, :language)
    end
  end
end
