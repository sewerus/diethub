Rails.application.routes.draw do

  #root
  root to: 'pages#start_page'

  #static
  get '/abouts' => 'pages#abouts', as: :abouts

  #devise
  devise_for :users

  #users
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

  #products
  resources :products
  patch '/products' => 'products#create', as: :create_product
  patch '/products/:id' => 'products#update', as: :update_product

  #meals
  resources :meals
  patch '/meals' => 'meals#create', as: :create_meal
  patch '/meals/:id' => 'meals#update', as: :update_meal
  get '/meals/:id/edit_products' => 'meals#edit_products', as: :edit_meal_products
  patch '/meals/:id/update_products' => 'meals#update_products', as: :update_meal_products
  patch '/meals/:id/add_product/:product_id' => 'meals#add_product', as: :add_product_to_meal
  patch '/meals/:id/remove_product/:product_id' => 'meals#remove_product', as: :remove_product_from_meal
  patch '/meals/:id/update_product_amount/:product_id' => 'meals#udpate_product_amount', as: :update_product_amount

  #recipe
  resources :recipes, only: [:edit, :destroy]
  patch '/recipes/:meal_id' => 'recipes#create', as: :create_recipe

  #steps
  resources :steps, only: [:destroy]
  patch '/steps/:id' => 'steps#update', as: :update_step
  get '/steps/create_in_recipe/:id' => 'steps#create', as: :create_step

  #template_days
  resources :template_days, only: [:edit, :update, :destroy]
  get '/patients/:id/template_days' => 'template_days#index', as: :template_days
  get '/patients/:id/template_days/new' => 'template_days#new', as: :new_template_day
  patch '/template_days' => 'template_days#create', as: :create_template_day
  patch '/template_days/:id' => 'template_days#update', as: :update_template_day

  #template_day_parts
  resources :template_day_parts, only: [:edit, :update, :destroy]
  get '/template_day/:id/template_day_parts/new' => 'template_day_parts#new', as: :new_template_day_part
  patch '/template_day_parts' => 'template_day_parts#create', as: :create_template_day_part
  patch '/template_day_parts/:id' => 'template_day_parts#update', as: :update_template_day_part

  #template_day_part_meals
  resources :template_day_part_meals, only: [:destroy]
  get '/template_day_part/:id/add_meal' => 'template_day_part_meals#new', as: :new_template_day_part_meal
  get '/template_day_part/:id/add_meal/:meal_id' => 'template_day_part_meals#create', as: :create_template_day_part_meal

end
