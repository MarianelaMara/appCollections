Rails.application.routes.draw do  
  resources :collections do
    get :end_collection , to: 'collections#end_collections'
    get :end_revision , to: 'collections#end_revision'
    get :noviable_collection , to: 'collections#noviable_collection'
    get :redefinir_collection , to: 'collections#redefinir_collection'
    resources :articles
  end 
  post :create_bookings_makers, to: 'bookings#create_bookings_makers'
  resources :makers
  resources :providers
  resources :bookings 
  devise_for :users
   root "collections#index"
end
