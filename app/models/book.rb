# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                 :bigint           not null, primary key
#  isbn               :string
#  selected_languages :string           default([]), is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Book < ApplicationRecord
  AVAILABLE_LANGUAGES = %w[uk ru en].freeze # Site.settings.languages

  default_scope { order(created_at: :desc) }

  has_many :book_translations, dependent: :destroy
  has_many :chapters, dependent: :destroy

  before_validation :clean_selected_languages
  before_create :set_selected_languages
  after_create :generate_translations
  after_create :generate_chapters

  validates_presence_of :isbn

  # broadcasts_to ->(_book) { 'books' }, inserts_by: :prepend
  # broadcasts_to ->(_book) { 'admin_books' }, inserts_by: :prepend

  private

  def clean_selected_languages
    self.selected_languages = selected_languages.reject(&:blank?).uniq if selected_languages.present?
  end

  def set_selected_languages
    self.selected_languages = AVAILABLE_LANGUAGES if selected_languages.blank?
  end

  def generate_translations
    selected_languages.each do |language|
      translation = book_translations.find_or_create_by(language: language)
      translation.title ||= "Book title in #{language}"
      translation.save!
    end
  end

  def generate_chapters
    chapters.create!(position: 1)
  end

  # [{"book_id"=>5,
  # "book_translations"=>
  #  [{"title"=>"Title in en", "language"=>"en", "description"=>nil},
  #   {"title"=>"Title in ru", "language"=>"ru", "description"=>nil},
  #   {"title"=>"Title in uk", "language"=>"uk", "description"=>nil}],
  # "chapter_details"=>
  #  [{"position"=>1,
  #    "translations"=>
  #     [{"title"=>"Chapter title in uk", "content"=>nil, "language"=>"uk"},
  #      {"title"=>"Chapter title in ru", "content"=>nil, "language"=>"ru"},
  #      {"title"=>"Chapter title in en", "content"=>nil, "language"=>"en"}]}]}]
  def self.with_translations_and_chapters(id: nil)
    sql = <<-SQL
      SELECT
        books.id AS book_id,
        json_agg(DISTINCT jsonb_build_object('language', book_translations.language, 'title', book_translations.title, 'description', book_translations.description)) AS book_translations,
        json_agg(DISTINCT jsonb_build_object('position', chapters.position, 'translations', (
          SELECT json_agg(jsonb_build_object('language', chapter_translations.language, 'title', chapter_translations.title, 'content', chapter_translations.content))
          FROM chapter_translations
          WHERE chapter_translations.chapter_id = chapters.id
        ))) AS chapter_details
      FROM
        books
      LEFT JOIN
        book_translations
      ON
        books.id = book_translations.book_id
      LEFT JOIN
        chapters
      ON
        books.id = chapters.book_id
    SQL

    sql += " WHERE books.id = #{id}" if id.present?

    sql += ' GROUP BY books.id'

    result = ActiveRecord::Base.connection.execute(sql)

    result.map do |row|
      row['book_translations'] = JSON.parse(row['book_translations']) if row['book_translations']
      row['chapter_details'] = JSON.parse(row['chapter_details']) if row['chapter_details']
      row
    end
  end
end
