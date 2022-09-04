# frozen_string_literal: true

class CreateCategoriesItems < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_items do |t|
      t.references :category, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
    end

    add_index :categories_items, %i[category_id item_id], unique: true
  end
end
