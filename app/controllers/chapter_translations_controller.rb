class ChapterTranslationsController < ApplicationController
  before_action :set_book
  before_action :set_chapter
  before_action :set_translation, only: [:edit, :update, :destroy]

  def new
    @translation = @chapter.chapter_translations.build(language: params[:language])
  end

  def create
    @translation = @chapter.chapter_translations.build(translation_params)

    respond_to do |format|
      if @translation.save
        format.html { redirect_to book_chapter_path(@book, @chapter), notice: "Translation was successfully added." }
        format.turbo_stream {
          flash.now[:notice] = "Translation was successfully added."
          render turbo_stream: [
            turbo_stream.replace("chapter_translations", partial: "chapters/translations", locals: { chapter: @chapter }),
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

  def destroy
    @translation.destroy

    respond_to do |format|
      format.html { redirect_to book_chapter_path(@book, @chapter), notice: "Translation was successfully removed." }
      format.turbo_stream {
        flash.now[:notice] = "Translation was successfully removed."
        render turbo_stream: [
          turbo_stream.replace("chapter_translations", partial: "chapters/translations", locals: { chapter: @chapter }),
          turbo_stream.append("flash", partial: "shared/flash", locals: { flash: flash })
        ]
      }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @translation.update(translation_params)
        format.html { redirect_to book_chapter_path(@book, @chapter), notice: "Translation was successfully updated." }
        format.turbo_stream {
          flash.now[:notice] = "Translation was successfully updated."
          render turbo_stream: [
            turbo_stream.replace("chapter_#{@chapter.id}", partial: "chapters/chapter", locals: { chapter: @chapter }),
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

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_chapter
    @chapter = @book.chapters.find_by!(position: params[:chapter_position])
  end

  def set_translation
    @translation = @chapter.chapter_translations.find_by!(language: params[:id])
  end

  def translation_params
    params.require(:chapter_translation).permit(:title, :content, :language)
  end
end
