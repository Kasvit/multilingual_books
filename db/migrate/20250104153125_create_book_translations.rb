# frozen_string_literal: true

class CreateBookTranslations < ActiveRecord::Migration[8.0]
  def change
    create_table :book_translations do |t|
      t.references :book, null: false, foreign_key: true
      t.string :language, null: false
      t.string :title, null: false
      t.text :description
      t.timestamps
    end

    add_index :book_translations, %i[book_id language], unique: true

    execute <<-SQL
      CREATE INDEX book_translations_title_tsvector_idx#{' '}
      ON book_translations USING gin (to_tsvector('simple', title));
    SQL
  end
end
