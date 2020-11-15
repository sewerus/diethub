Rails.application.routes.draw do

  #root
  root to: 'pages#start_page'

  #devise
  devise_for :users

  resources :users
  resources :admins
  resources :dieticians
  resources :patients

  patch '/save_new_user' => 'users#save_new', as: :save_new
  get '/user/edit_password' => 'users#edit_password', as: :edit_password
  resource :user, only: [:edit_password] do
    collection do
      patch 'update_password'
    end
  end
  get '/users/:id/reset_password' => 'users#reset_password', as: :reset_password
  get '/my_patients' => 'patients#my_patients', as: :my_patients
end
