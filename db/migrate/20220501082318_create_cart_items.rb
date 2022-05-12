class CreateCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_items do |t|
      t.integer :item_id,       null: false
      t.integer :customer_id,   null: false
      t.integer :amount,        null: false

      # reference型?foreign_key: true にすると勝手にインデックス張られる
      # integerの状態でする場合は、add_foreign_key :対象のテーブル名, :指定先のテーブル になる(インデックスも勝手に張られる)

      t.timestamps
    end
  end
end
