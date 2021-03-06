Rails.application.routes.draw do

  #root
  root to: 'pages#start_page'

  #static pages
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

  #days
  get '/days/new/:user_id/:date' => 'days#new', as: :new_day
  patch '/day' => 'days#create', as: :create_day
  get '/patients/:user_id/callendar' => 'days#index', as: :days
  get '/callendar/show_day/:user_id(/:date)' => 'days#show_day', as: :show_day
  get '/callendar/show_week/:user_id' => 'days#show_week', as: :show_week
  get '/callendar/show_month/:user_id' => 'days#show_month', as: :show_month
  get '/callendar/change_week/:date/:user_id' => 'days#change_week', as: :change_callendar_week
  get '/callendar/change_day/:date/:user_id' => 'days#change_day', as: :change_callendar_day
  get '/callendar/change_month/:date/:user_id' => 'days#change_month', as: :change_callendar_month

  #day_parts
  get '/day_parts/:id' => 'day_parts#show', as: :show_day_part
  get '/day_parts/:id/edit' => 'day_parts#edit', as: :edit_day_part
  get '/day_parts/:id/update_by/:chosen_id' => 'day_parts#update', as: :update_day_part

  #day_part_meals
  get '/day_part_meals/:id/set_as_eaten' => 'day_part_meals#set_as_eaten', as: :set_day_part_meal_as_eaten

  #trainings
  resources :trainings, only: [:show, :edit, :destroy]
  get '/trainings/new/:user_id/:date' => 'trainings#new', as: :new_training
  patch '/trainings' => 'trainings#create', as: :create_training
  patch '/trainings/:id' => 'trainings#update', as: :update_training

  #measurements
  resources :measurements, only: [:show, :edit, :destroy]
  get '/measurements/new/:user_id/:date' => 'measurements#new', as: :new_measurement
  patch '/measurements' => 'measurements#create', as: :create_measurement
  patch '/measurements/:id' => 'measurements#update', as: :update_measurement
  get '/measurements/:id/show_files' => 'measurements#show_files', as: :show_measurement_files
  
  #measurement_files
  resources :measurement_files, only: [:destroy]
  post '/measurement_files/upload_for_measurement' => 'measurement_files#upload_for_measurement', as: :upload_for_measurement

  #messages
  resources :messages, except: [:show, :new, :create]
  get '/messages/new/:id' => 'messages#new', as: :new_message
  patch '/messages' => 'messages#create', as: :create_message
  get '/messages/read/:id' => 'messages#set_messages_as_read', as: :set_messages_as_read

  #charts
  get '/charts/:id' => 'charts#show', as: :show_charts
  get '/charts/:id/calories(/:start_date/:end_date)' => 'charts#calories', as: :calories_chart
  get '/charts/:id/fat(/:start_date/:end_date)' => 'charts#fat', as: :fat_chart
  get '/charts/:id/carbo(/:start_date/:end_date)' => 'charts#carbo', as: :carbo_chart
  get '/charts/:id/protein(/:start_date/:end_date)' => 'charts#protein', as: :protein_chart
  get '/charts/:id/sleep(/:start_date/:end_date)' => 'charts#sleep', as: :sleep_chart
  get '/charts/:id/trainings(/:start_date/:end_date)' => 'charts#trainings', as: :trainings_chart
  get '/charts/:id/weight(/:start_date/:end_date)' => 'charts#weight', as: :weight_chart
  get '/charts/:id/plan(/:start_date/:end_date)' => 'charts#plan', as: :plan_chart
end
