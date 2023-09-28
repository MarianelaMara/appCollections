Rails.application.routes.draw do  
  resources :collections do
    resources :articles
  end 
  devise_for :users
   root "collections#index"
end
