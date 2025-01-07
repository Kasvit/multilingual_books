# frozen_string_literal: true

module Admin
  class ChapterTranslationsController < AdminController
    before_action :set_book
    before_action :set_chapter
    before_action :set_translation, only: %i[edit update destroy]

    def new
      @translation = @chapter.chapter_translations.build(language: params[:language])
    end

    def create
      @translation = @chapter.chapter_translations.build(translation_params)

      respond_to do |format|
        if @translation.save
          format.html do
            redirect_to admin_book_chapter_path(@book, @chapter), notice: 'Translation was successfully added.'
          end
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
          format.html do
            redirect_to admin_book_chapter_path(@book, @chapter), notice: 'Translation was successfully updated.'
          end
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
        format.html do
          redirect_to admin_book_chapter_path(@book, @chapter), notice: 'Translation was successfully removed.'
        end
        format.turbo_stream { flash.now[:notice] = 'Translation was successfully removed.' }
      end
    end

    private

    def set_book
      @book = Book.find(params[:book_id])
    end

    def set_chapter
      @chapter = @book.chapters.find_by!(position: params[:chapter_position])
    end

    def set_translation
      @translation = @chapter.chapter_translations.find_by!(language: params[:language])
    end

    def translation_params
      params.require(:chapter_translation).permit(:title, :content, :language)
    end
  end
end
