class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items.all
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    @orders_items = @order.order_items

      if @order.order_status == "入金確認"
        #　紐付く注文ステータスが入金確認になったら
        @orders_items.each do |order_item|
        # 注文商品の各商品の制作ステータスを制作待ちにして更新
          order_item.update(production_status: 1)
        end
      end
    redirect_to admin_order_path(@order)

  end

  private
  def order_params
    params.require(:order).permit(:order_status)
  end
end
