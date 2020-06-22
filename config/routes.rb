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
      get 'notice_approval'
      patch 'update_notice_approval'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/work_log',to: 'attendances#work_log'
    end

    resources :attendances, only: :update  do
      member do
        get 'edit_approval'
        patch 'update_approval'
        get 'edit_overtime'
        patch 'update_overtime'
        get 'notice_approval'
        get 'notice_one_month'
        get 'notice_overtime'
        patch 'update_notice_approval'
        patch 'update_notice_one_month'
        patch 'update_notice_overtime'
      end
    end
    Rails.application.routes.draw do
      resources :users do
        collection { post :import }
      end
    end
      collection do
          get 'search'
        end
  end

  if defined? Rails::Console
   if defined? Hirb
    Hirb.enable
   end
  end

end
