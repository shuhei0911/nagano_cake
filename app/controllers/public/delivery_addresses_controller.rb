class Public::DeliveryAddressesController < ApplicationController
  #ログインチェックを行う
  before_action :ensure_correct_customer

  def index
    #新規登録用のインスタンス変数
    @new_delivery_address = DeliveryAddress.new
    #登録されている配送先の取得
    @delivery_addresses = DeliveryAddress.where(customer_id: current_customer)
  end

  def create
    #POSTで受け取った配送先の情報をストロングパラメータを使って取得
    @delivery_addresses = DeliveryAddress.new(delivery_params)
    #customer_idの値にcurrent_customer(ログイン中)のidを入れる
    @delivery_addresses.customer_id = current_customer.id
    #取得した情報を元に保存
    if @delivery_addresses.save
      #保存できた場合は操作中の画面に戻る
      redirect_back(fallback_location:root_path)
    else
      #保存できなかった場合は配送先テーブルを取得し、indexを表示する
      @delivery_addresses = DeliveryAddress.where(customer_id: current_customer)
      render 'index'
    end
  end

  def edit
    #編集対象の配送先のidを元にテーブルからデータを取得する
    @delivery_address = DeliveryAddress.find(params[:id])
    #取得したユーザーのidとログイン中のユーザーのidが一致しない場合
    if @delivery_address.customer_id != current_customer.id
      #トップページに移動する
      redirect_to root_path
    end
  end

  def update
    #編集対象の配送先のidを元にテーブルからデータを取得する
    @delivery_address = DeliveryAddress.find(params[:id])
    #POSTで受け取った配送先の情報を更新する
    if @delivery_address.update(delivery_params)
      #更新できた場合は配送先一覧にリダイレクトする
      redirect_to delivery_addresses_path
    else
      #更新できなかった場合は編集画面のままにしておく
      render 'edit'
    end
  end

  def destroy
    #削除対象の配送先のidを元にテーブルからデータを取得する
    @delivery_address = DeliveryAddress.find(params[:id])
    #対象データの削除を行う
    @delivery_address.destroy
    #操作中の画面に戻る
    redirect_back(fallback_location:root_path)
  end

  private

  #ストロングパラメータの設定
  def delivery_params
    params.require(:delivery_address).permit(:post_code, :address, :name)
  end

  def ensure_correct_customer
    #current_customerが取得できない場合
    if current_customer == nil
      #ログイン画面に飛ばす
      redirect_to new_customer_session_path
    end
  end

end
