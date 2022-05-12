class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #バリデーションの設定
  validates :last_name, :first_name, :kana_last_name, :kana_first_name,
            :post_code, :address, :telephone, presence: true
  validates :email, uniqueness: true
  has_many :delivery_addresses, dependent: :destroy
  #has_one :cart_items

  #customerがcart_itemの所有者
  has_many :cart_items, dependent: :destroy
  #customerがordersの所有者
  has_many :orders, dependent: :destroy

  def full_my_address
    '〒' + post_code + ' ' + address
  end
  #enum is_deleted: { 有効: false, 退会: true }
end
