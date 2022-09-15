# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :restaurant, foreign_key: true, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.decimal :price, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :items, :title, unique: true
  end
end
