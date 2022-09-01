# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :restaurant, foreign_key: true
      t.integer :status, null: false
      t.decimal :total_price, null: false
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
