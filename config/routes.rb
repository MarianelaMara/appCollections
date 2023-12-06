Rails.application.routes.draw do  
  resources :orders, only: [:index, :new, :create, :show]

  # get 'orders/new'
  # get 'orders/create'
  # get 'orders/show'
  resources :collections do
    post "/finalizar_coleccion" , to: 'collections#finalizar_coleccion'
    get :end_collection , to: 'collections#end_collections'
    get :end_revision , to: 'collections#end_revision'
    get :noviable_collection , to: 'collections#noviable_collection'
    get :redefinir_collection , to: 'collections#redefinir_collection'
    resources :articles
  end 
  get :booking_delayed , to: 'providers#booking_delayed'
  get :booking_canceled , to: 'providers#booking_canceled'
  get :continuar_provedor , to: 'providers#continuar_provedor'
  get :cambiar_provedor , to: 'providers#cambiar_provedor'
  get :finalizar_pedido , to: 'orders#finalizar_pedido'
  get :recepcion_lotes , to: 'orders#recepcion_lotes'
  post :create_bookings_makers, to: 'bookings#create_bookings_makers'
  post :nueva_bookings, to: 'bookings#nueva_bookings'
  resources :makers
  resources :providers
  resources :bookings 
  resources :order_items
  devise_for :users
   root "collections#index"
end
