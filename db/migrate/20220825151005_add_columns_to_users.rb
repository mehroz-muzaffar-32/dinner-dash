class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.string :full_name, null: false
      t.string :display_name, null: true
      t.string :type
    end
  end
end
