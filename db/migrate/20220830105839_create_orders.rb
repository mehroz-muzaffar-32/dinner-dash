# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true, null: false
      t.references :restaurant, foreign_key: true, null: false
      t.integer :status, default: 0, null: false
      t.datetime :submitted_at
      t.decimal :total_price

      t.timestamps
    end
  end
end
