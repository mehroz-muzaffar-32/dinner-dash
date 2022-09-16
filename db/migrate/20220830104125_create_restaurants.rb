# frozen_string_literal: true

class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false, default: '', index: { unique: true }

      t.timestamps
    end
  end
end
