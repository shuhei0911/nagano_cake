class Admin::CustomersController < ApplicationController
  def index
    #カスタマー一覧用の情報を取得する
    @customers = Customer.page(params[:page]).reverse_order
  end

  def show
    #カスタマーモデルから一つのデータをみるけてくる（IDを使う）
    @customer = Customer.find(params[:id])
  end

  def edit
    #カスタマーモデルから一つのデータをみるけてくる（IDを使う）
    @customer = Customer.find(params[:id])
  end

  def update
    #カスタマーモデルから一つのデータをみるけてくる（IDを使う）
    @customer = Customer.find(params[:id])
    #取得したデータに対して、フォームから送られてきた情報をもとに更新を行う(customer_paramsを経由)
    if @customer.update(customer_params)
      #成功した場合は管理側の顧客情報詳細画面
      redirect_to admin_customer_path(@customer)
    else
      #失敗した場合は編集画面に滞在する
      render :edit
    end
  end

  #コントローラー内部で処理する必要があるためprivate
  private

  def customer_params
    #テーブル（今回はカスタマー）に対し、フォームから受け取る情報をフィルタリングする。
    params.require(:customer).permit(:last_name, :first_name, :kana_last_name, :kana_first_name, :post_code, :address, :telephone, :is_deleted)
  end

end
