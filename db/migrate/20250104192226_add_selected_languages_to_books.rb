# frozen_string_literal: true

class AddSelectedLanguagesToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :selected_languages, :string, array: true, default: []
  end
end
