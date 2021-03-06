class UsersController < ApplicationController
  include AttendancesHelper

  before_action :set_user, only: [:show,:edit,:update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in?, only: [:index,:show,:edit,:update]
  before_action :logged_in_user, only: [:show,:edit,:update,:destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_user, only: [:index,:edit,:update,:destroy]
  before_action :admin_or_correct_user, only: [:edit,:update]
  before_action :set_one_month, only: :show
  before_action :superior_or_correct_user, only: :show

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
    unless @user.admin?
      @users = User.all
      @users.each do |user|
      @attendance = @user.attendances.where(user_id: @user.id)
      end
      @approval_numbers = Attendance.where(instructor: @user,change: false).count
      @one_month_numbers = Attendance.where(one_month_instructor: @user,one_month_change: false).count
      @overtime_numbers = Attendance.where(overtime_instructor: @user,overtime_change: false).count
      @worked_sum = @attendances.where.not(started_at: nil).count
    else
      redirect_to root_path
      flash[:danger]="ページがありません"
    end
  end

  def index
    @users = User.all.order(id: "ASC")
  end

  def search
    if params[:search] == ""
      render users_path
        flash[:danger] = "検索結果がありません"
    else
       @users = User.paginate(page: params[:page]).search(params[:search])
       render users_path
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success]  ="#{@user.name}さんの情報を更新しました。"
      redirect_to users_url
    else
      flash[:danger]="情報の更新が失敗しました。<br>" + @user.errors.full_messages.join('<br>')
      redirect_to users_url
    end
  end

  def destroy
    @user.destroy
    flash[:success]  ="#{@user.name}さんの情報を削除しました。"
    redirect_to users_url
  end

  def import
    if User.import(params[:file])
      flash[:success] = "ユーザー情報を追加しました。"
    else
      flash[:danger] = "情報の更新に失敗しました。"
    end
    redirect_to users_url
  end

  def working_users
  end

  def update_overtime
    overtime_params.each do |id,item|
    attendance = Attendance.find(params[:id])
      if  attendance.update_attributes(item)
        flash[:success] = "残業申請完了"
      else
        flash[:danger] = "残業申請失敗"
      end
    redirect_to current_user
    end
  end

  private

    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation,:affiliation,
                                    :employee_number,:uid, :basic_work_time,:id,
                                    :designated_work_start_time,:designated_work_end_time)
    end
end
