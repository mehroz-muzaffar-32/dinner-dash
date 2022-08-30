class CreateOrderLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_line_items do |t|
      t.references :order, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :quantity_ordered
      t.decimal :sub_total
    end
  end
end
