# frozen_string_literal: true

class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.references :user, foreign_key: true, index: { unique: true }, null: false

      t.timestamps
    end
  end
end
