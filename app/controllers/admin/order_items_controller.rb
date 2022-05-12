class Admin::OrderItemsController < ApplicationController
  before_action :authenticate_admin!
  def update
      @order_item = OrderItem.find(params[:id])
      @order = @order_item.order
      @order_items = @order.order_items
      @order_item.update(order_items_params)

      if @order_items.where(production_status: "製作中").count >= 1
        # 紐付く注文商品の制作ステータスが１つでも製作中になったら注文ステータスを製作中にして更新する
        @order.update(order_status: 1)
      end

      if @order.order_items.count == OrderItem.where(order_id: @order, production_status: "制作完了").count
        # 紐付く注文商品の制作ステータスが全て制作完了になったら注文ステータスを発送準備中にして更新する
        @order.update(order_status: 3)
      end

      redirect_to admin_order_path(@order)
  end

  private
  def order_items_params
      params.require(:order_item).permit(:production_status)
  end
end
