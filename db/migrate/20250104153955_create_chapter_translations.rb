# frozen_string_literal: true

class CreateChapterTranslations < ActiveRecord::Migration[8.0]
  def change
    create_table :chapter_translations do |t|
      t.references :chapter, null: false, foreign_key: true
      t.string :language, null: false
      t.string :title, null: false
      t.text :content
      t.timestamps
    end

    add_index :chapter_translations, %i[chapter_id language], unique: true
  end
end
