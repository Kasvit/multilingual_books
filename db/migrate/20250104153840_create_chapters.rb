# frozen_string_literal: true

class CreateChapters < ActiveRecord::Migration[8.0]
  def change
    create_table :chapters do |t|
      t.references :book, null: false, foreign_key: true
      t.integer :position, null: false
      t.timestamps
    end

    add_index :chapters, %i[book_id position], unique: true
  end
end
