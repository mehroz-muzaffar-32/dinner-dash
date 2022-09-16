# frozen_string_literal: true

class CreateCategoriesItems < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_items do |t|
      t.references :category, foreign_key: true
      t.references :item, foreign_key: true
      t.index %i[category_id item_id], unique: true

      t.timestamps
    end
  end
end
