# frozen_string_literal: true

class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.references :container, polymorphic: true, index: true, null: false
      t.references :item, foreign_key: true, null: false
      t.integer :quantity_ordered, default: 1, null: false

      t.timestamps
    end
  end
end
