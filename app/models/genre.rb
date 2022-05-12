class Genre < ApplicationRecord
  # has_many :products,dependent :destroy
  has_many :items
end