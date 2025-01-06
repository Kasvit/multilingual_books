# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 20_250_104_192_226) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pg_catalog.plpgsql'

  create_table 'book_translations', force: :cascade do |t|
    t.bigint 'book_id', null: false
    t.string 'language', null: false
    t.string 'title', null: false
    t.text 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index "to_tsvector('simple'::regconfig, (title)::text)", name: 'book_translations_title_tsvector_idx', using: :gin
    t.index %w[book_id language], name: 'index_book_translations_on_book_id_and_language', unique: true
    t.index ['book_id'], name: 'index_book_translations_on_book_id'
  end

  create_table 'books', force: :cascade do |t|
    t.string 'isbn'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'selected_languages', default: [], array: true
  end

  create_table 'chapter_translations', force: :cascade do |t|
    t.bigint 'chapter_id', null: false
    t.string 'language', null: false
    t.string 'title', null: false
    t.text 'content'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[chapter_id language], name: 'index_chapter_translations_on_chapter_id_and_language', unique: true
    t.index ['chapter_id'], name: 'index_chapter_translations_on_chapter_id'
  end

  create_table 'chapters', force: :cascade do |t|
    t.bigint 'book_id', null: false
    t.integer 'position', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[book_id position], name: 'index_chapters_on_book_id_and_position', unique: true
    t.index ['book_id'], name: 'index_chapters_on_book_id'
  end

  add_foreign_key 'book_translations', 'books'
  add_foreign_key 'chapter_translations', 'chapters'
  add_foreign_key 'chapters', 'books'
end
