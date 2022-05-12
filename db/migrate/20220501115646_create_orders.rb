class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :customer_id,       null: false
      t.integer :shipping_fee,      null: false
      t.integer :total_price,       null: false
      t.integer :payment,           null: false,  default: 0
      t.integer :order_status,      null: false,  default: 0
      t.string :delivery_postcode,  null: false
      t.string :delivery_address,   null: false
      t.string :delivery_name,      null: false

      t.timestamps
    end
  end
end
