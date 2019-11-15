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
      
      get 'attendances/work_log'
      get 'attendances/search_work_log', to:'attendance#search'
      
    end
  
    resources :attendances, only: :update  do
      member do
        get 'edit_overtime'
        patch 'update_overtime'
        get 'edit_approval'
        patch 'update_approval'
        get 'notice_approval'
        get 'notice_edit_one_month'
        get 'notice_overtime'
        patch 'update_notice_approval'
        patch 'update_notice_edit_one_month'
        patch 'update_notice_overtime'
    end
    end  
      collection { post :import }
  end
end
