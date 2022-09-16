# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :restaurant, foreign_key: true, null: false
      t.string :title, null: false, default: '', index: { unique: true }
      t.text :description, null: false, default: ''
      t.decimal :price, null: false, default: 0
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
