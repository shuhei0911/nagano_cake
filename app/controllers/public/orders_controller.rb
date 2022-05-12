class Public::OrdersController < ApplicationController
  before_action :ensure_correct_customer

  def index
    @orders = Order.where(customer_id: current_customer)
  end

  def new
    @order = Order.new
    @address = DeliveryAddress.where(customer_id: current_customer)
  end

  def create
    @order = Order.new(order_params)
    @cart_items = CartItem.where(customer_id: current_customer)
    if @cart_items.exists?
      @order.save
      @cart_items.each do |item|
        OrderItem.create(
          order_id: @order.id,
          item_id: item.item.id,
          price_on_purchase: item.item.price,
          quantity: item.amount
        )
      end
      CartItem.where(customer_id: current_customer).destroy_all
      redirect_to complete_orders_path
    else
      redirect_to cart_items_path
    end
  end

  def show
    if params[:id] == 'confirm'
      redirect_to new_order_path
    else
      @order = Order.find(params[:id])
      @order_item = OrderItem.where(order_id: @order)
      @itemtotal = 0
    end
    #binding.pry
  end

  def confirm
    @order = Order.new(order_params)
    @select_address = params[:order][:select_address]
    #自分の住所を選んだ時
    if @select_address == '0'
      @order.delivery_postcode = current_customer.post_code
      @order.delivery_address = current_customer.address
      @order.delivery_name = current_customer.last_name + current_customer.first_name
    #既存の住所を選んだ時
    elsif @select_address == '1'
      if params[:order][:delivery_address_id].presence
        @address = DeliveryAddress.find(params[:order][:delivery_address_id])
        @order.delivery_postcode = @address.post_code
        @order.delivery_address = @address.address
        @order.delivery_name = @address.name
      end
    end
    #既存の住所を選んだ時,配送先の情報が入っているか確認する
    if @order.delivery_postcode.presence && @order.delivery_address.presence && @order.delivery_name.presence
      @cart_items = CartItem.where(customer_id: current_customer)
      @temp_sum = 0
      render :confirm
    else
      redirect_to new_order_path
    end
  end

  def complete
  end

  private

  def order_params
      params.require(:order).permit(:customer_id, :shipping_fee, :order_status, :total_price, :payment, :delivery_postcode, :delivery_address, :delivery_name)
  end

  def ensure_correct_customer
    #current_customerが取得できない場合
    if current_customer == nil
      #ログイン画面に飛ばす
      redirect_to new_customer_session_path
    end
  end
end