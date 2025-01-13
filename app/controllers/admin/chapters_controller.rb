# frozen_string_literal: true

module Admin
  class ChaptersController < AdminController
    before_action :set_book
    before_action :set_chapter, only: %i[show edit update destroy]

    def index
      @chapters = @book.chapters
    end

    def show
      @prev_chapter_id = @book.chapters.find { |ch| ch.position == @chapter.position - 1 }&.id
      @next_chapter_id = @book.chapters.find { |ch| ch.position == @chapter.position + 1 }&.id
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
          format.html do
            redirect_to admin_book_chapter_url(@book, @chapter), notice: 'Chapter was successfully created.'
          end
          format.turbo_stream { flash.now[:notice] = 'Chapter was successfully created.' }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream { render :create, status: :unprocessable_entity }
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
          format.html do
            redirect_to admin_book_chapter_url(@book, @chapter), notice: 'Chapter was successfully updated.'
          end
          format.turbo_stream { flash.now[:notice] = 'Chapter was successfully updated.' }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render :update, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @chapter.destroy

      respond_to do |format|
        format.html { redirect_to admin_book_chapters_url(@book), notice: 'Chapter was successfully destroyed.' }
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
