# frozen_string_literal: true

module Admin
  class ChaptersController < AdminController
    before_action :set_book
    before_action :set_chapter, only: %i[show edit update destroy]
    def show
      @prev_chapter = @book.chapters.where('position < ?', @chapter.position).first
      @next_chapter = @book.chapters.where('position > ?', @chapter.position).order(position: :asc).last
    end

    def new
      @chapter = @book.chapters.build
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_to admin_book_chapters_path(@book)
        end
      end
    end

    def create
      @chapter = @book.chapters.build(chapter_params)

      respond_to do |format|
        if @chapter.save
          format.turbo_stream { flash.now[:notice] = 'Chapter was successfully created.' }
        else
          format.turbo_stream { render :new, status: :unprocessable_entity }
        end
      end
    end

    def edit
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_to admin_book_chapters_path(@book)
        end
      end
    end

    def update
      respond_to do |format|
        if @chapter.update(chapter_params)
          format.turbo_stream { flash.now[:notice] = 'Chapter was successfully updated.' }
        else
          format.turbo_stream { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @chapter.destroy

      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = 'Chapter was successfully destroyed.' }
      end
    end

    private

    def set_book
      @book = Book.includes(:translations, :chapters)
                  .find(params[:book_id])
    end

    def set_chapter
      @chapter = @book.chapters.find(params[:id])
    end

    def chapter_params
      params.require(:chapter).permit(:position, :title, :content)
    end
  end
end
