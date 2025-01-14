# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :description
      t.string :language, null: false
      t.boolean :hidden, default: false
      t.string :hidden_reason
      t.boolean :published, default: false, null: false
      t.integer :original_book_id, index: true
      t.timestamps
    end

    add_index :books, %i[title language], unique: true
    add_index :books, %i[original_book_id language], unique: true
    add_index :books, :published
  end
end
