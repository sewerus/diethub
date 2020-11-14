Rails.application.routes.draw do

  #root
  root to: 'users#index'

  #devise
  devise_for :users

  resources :users
  resources :admins
  resources :dieticians
  resources :patients

  patch '/save_new_user' => 'users#save_new', as: :save_new
end
