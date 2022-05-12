class DeliveryAddress < ApplicationRecord
    #バリデーションの追加(郵便番号、住所、宛名のないデータを登録できなくする。)
  validates :post_code, :address, :name, presence: true
  #外部キーの設定(カスタマーへ)
  belongs_to :customer

  #住所をまとめて表示する
  def full_address
    '〒' + post_code + ' ' + address + ' ' + name
  end
end
