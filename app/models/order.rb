class Order < ApplicationRecord
  belongs_to :customer

  enum order_status: { 入金待ち: 0, 入金確認: 1, 制作中: 2, 発送準備中: 3, 発送済み: 4 }
  enum payment: { クレジットカード: 0, 銀行振込: 1 }
  has_many :order_items, dependent: :destroy

  def add_tax_price
    (self.price * 1.10).round
  end
end
