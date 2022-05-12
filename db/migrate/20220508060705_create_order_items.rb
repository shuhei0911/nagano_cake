class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :item_id
      t.integer :price_on_purchase
      t.integer :quantity
      t.integer :production_status

      t.timestamps
    end
  end
end
