class Public::ItemsController < ApplicationController
  def index
    @items = Item.where(sales_status: true).page(params[:page]).per(8)
    @item = Item.where(sales_status: true)
  end

  def show
    @item = Item.find(params[:id])
    #カートに追加するため
    @cart_items = CartItem.new
  end
end
