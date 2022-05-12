class Public::CartItemsController < ApplicationController
  before_action :ensure_correct_customer

  def index
    #会員idがログイン中のユーザーidのレコードを全て取得する
    @cart_items = CartItem.where(customer_id: current_customer)
    #カート内の合計用の変数
    @temp_sum = 0
  end

  def create
    #フォームから値を受け取る
    @cart_items = CartItem.new(cart_item_params)
    #既存のデータ内に追加しようとしている商品があればレコードを取得する
    @cart_item_update = CartItem.find_by(customer_id: current_customer, item_id: @cart_items.item_id )
    #レコードが取得できれば
    if @cart_item_update
      #既存のレコードの数量にフォームから受け取った値を加える
      new_amounts = @cart_item_update.amount + @cart_items.amount
      #数値が10を超える場合は10に値を固定させる
      if new_amounts >= 10
        new_amounts = 10
      end
      #既存のレコードの数量のみ更新
      @cart_item_update.update_attribute(:amount, new_amounts)
      #フォームから受け取った情報は使用しないので削除する
      @cart_items.delete
    else
      #新しくデータを保存する
      @cart_items.save
    end
    redirect_to cart_items_path
  end

  def update
    @cart_item = CartItem.find(params[:id])
    #createと同様カートには10個しか入らないようにする
    if @cart_item.amount >= 10
      @cart_item.amount = 10
    end
    @cart_item.update(cart_item_params)
    redirect_back(fallback_location:root_path)
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_back(fallback_location:root_path)
  end

  def destroy_all
    #ログイン中のユーザーに紐づいているデータを全て削除
    CartItem.where(customer_id: current_customer).destroy_all
    redirect_back(fallback_location:root_path)
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :customer_id, :amount)
  end

  def ensure_correct_customer
    #current_customerが取得できない場合
    if current_customer == nil
      #ログイン画面に飛ばす
      redirect_to new_customer_session_path
    end
  end
end
