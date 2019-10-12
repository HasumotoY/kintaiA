class UsersController < ApplicationController
  before_action :set_user, only: [:show,:edit,:update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in?, only: [:index,:show,:edit,:update]
  before_action :logged_in_user, only: [:show,:edit,:update,:destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_user, only: [:index,:edit,:update,:destroy]
  before_action :admin_or_correct_user, only: [:edit,:update]
  before_action :set_one_month, only: [:show]
  
  
  before_action :admin_or_correct_user, only: :show
  
  EDIT_ERROR_MESSAGE = "入力内容に問題があります。"
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "登録が完了しました。"
      redirect_to @user
    else
      render new_user_path
    end
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  def index
    @users = User.paginate(page: params[:page]).search(params[:search])
  end
  
  def search
    if params[:search] == ""
      render users_url
        flash[:danger] = "検索結果がありません"
    else    
       @users = User.paginate(page: params[:page]).search(params[:search])
       render users_url
    end 
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success]  ="#{@user.name}さんの情報を更新しました。"
      redirect_to users_path
    else
      flash[:danger]="情報の更新が失敗しました。<br>" + @user.errors.full_messages.join('<br>')
      redirect_to users_url
    end
  end

  def destroy
    @user.destroy
    flash[:success]  ="#{@user.name}さんの情報を削除しました。"
    redirect_to users_path
  end
  
  def import
    User.import(params[:file])
    redirect_to users_url
  end
  
  def working_users
    User.all.each do |users|
      users.attendances.any?{|day|}
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation,:affiliation,
                                    :employee_number,:uid, :basic_work_time,:id,
                                    :designated_work_start_time,:designated_work_end_time)
    end
end
