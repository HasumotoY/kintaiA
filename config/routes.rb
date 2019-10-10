Rails.application.routes.draw do
  root "home#top"
  
  #ログイン機能
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  #勤務中社員一覧
  get 'working_users', to:'users#working_users' 
  
  #拠点一覧
  resources :bases 
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'work_log'
      get 'attendances/edit_overtime'
      patch 'attendances/update_overtime'
    end
    resources :attendances, only: :update
    collection { post :import }
  end
end
