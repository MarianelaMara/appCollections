Rails.application.routes.draw do  
  resources :collections do
    get :end_collection , to: 'collections#end_collections'
    get :end_revision , to: 'collections#end_revision'
    resources :articles
  end 
  devise_for :users
   root "collections#index"
end
