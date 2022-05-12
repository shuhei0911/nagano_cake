Rails.application.routes.draw do
  namespace :public do
    get 'delivery_addresses/edit'
    get 'delivery_addresses/index'
  end
  #namespace :public do
    #get 'orders/complete'
    #get 'orders/confirm'
    #get 'orders/index'
    #get 'orders/new'
    #get 'orders/show'
  #end
  #namespace :public do
    #get 'cart_items/index'
  #end
  #namespace :public do
    #get 'customers/show'
    #get 'customers/unsubscribe'
  #end
  #namespace :public do
    #get 'homes/top'
    #get 'homes/about'
  #end
  #namespace :admin do
    #get 'customers/index'
    #get 'customers/show'
    #get 'customers/edit'
  #end
  #namespace :admin do
    #get 'items/index'
    #get 'items/new'
    #get 'items/create'
    #get 'items/show'
    #get 'items/edit'
    #get 'items/update'
  #end
# 顧客用
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

get 'admin' => 'admin/homes#top'

get '/items' => 'public/items#index'

get '/items/:id' => 'public/items#show' , as: 'item'

get '/about' => 'public/homes#about'


  namespace :admin do
    resources :items
    resources :genres, only: [:index, :create, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :order_items, only: [:update]
    resources :orders, only:[:show, :update]
  end

  devise_scope :customer do
    get '/customers', to: 'public/registrations#new'
  end
  get 'customers/mypage' => 'public/customers#show'
  get 'customers/unsubscribe' => 'public/customers#unsubscribe'
  patch 'customers/withdraw' => 'public/customers#withdraw'
  root to: 'public/homes#top'
  get '/about' => 'public/homes#about'

  resources :delivery_addresses, module: :public, :except => [:new, :show]
  resources :cart_items, module: :public, :except => [:new, :show, :edit] do
    collection do
      delete 'destroy_all'
    end
  end

  resources :orders, module: :public, :only => [:new,:create,:index,:show] do
    collection do
      post 'confirm'
      get 'complete'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
