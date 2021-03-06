class AttendancesController < ApplicationController
include AttendancesHelper

  before_action :set_user,only: [:edit_one_month,:update_approval]
  before_action :logged_in_user, only: [:update,:edit_one_month]
  before_action :set_one_month,only: [:edit_one_month,:update_approval]
  before_action :admin_or_correct_user, only: [:update,:edit_one_month]

  UPDATE_ERROR_MSG = "登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
        if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
          flash[:info] = "おはようございます。"
        else
          flash[:danger]=UPDATE_ERROR_MSG
        end
    elsif @attendance.started_at.present? &&  @attendance.finished_at.nil?
        if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
          flash[:info] = "お疲れ様でした。"
        else
          flash[:danger]  =UPDATE_ERROR_MSG
        end
    end
    redirect_to @user
  end

  def  edit_one_month
    if @user.admin?
      redirect_to root_path
      flash[:danger]="ページがありません"
    end
  end

  def update_one_month
    if attendances_invalid?
      ActiveRecord::Base.transaction do
        attendances_params.each do |id,item|
          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
        end
      end
      flash[:success] = "勤怠を更新しました。"
      redirect_to user_url(date: params[:date])
    else
      flash[:danger] = "無効なデータがあったため,更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
    end
  rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効なデータがあったため、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  #残業申請機能
  def edit_overtime
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end

  def update_overtime
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
      if @attendance.overtime_approval.nil?
          @attendance.update_attributes(overtime_params)
          User.all.each do |user|
          if @attendance.overtime_instructor.to_i == user.id
            flash[:success] = "#{user.name}に残業を申請しました。"
          end
        end
      else
        flash[:danger] = "残業を申請できませんでした"
      end
    redirect_to @user
  end

  #所属長申請
  def update_approval
    if @approval_numbers.to_i == 0
      attendance = @attendances.where(worked_on: @first_day)
      attendance.update(approval_params)
      flash[:success] = "所属長承認申請完了"
    else
      flash[:danger] = "申請処理が失敗しました"
    end
    redirect_to user_url(date: @first_day)
  end

  #所属長承認
  def notice_approval
    @superior = User.find(params[:user_id])
    @attendance = Attendance.where(instructor: @superior,change: false)
    @attendance.each do |attendance|
      @users = User.find(attendance.user_id)
    end
  end

  def update_notice_approval
    @user = User.find(params[:user_id])
    if approval_invalid?
      ActiveRecord::Base.transaction do
        notice_approval_params.each do |id,item|
          attendance = Attendance.find(id)
          attendance.update_attributes(item)
        end
      end
      flash[:success] = "承認完了"
      end
      redirect_to user_url(@user)
    rescue ActiveRecord::RecordInvalid
      flash[:danger]="承認失敗"
      redirect_to user_url(@user)
  end

  #勤怠変更申請
  def update_one_month_approval
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
      if @attendance.overtime_approval.nil?
          @attendance.update_attributes(one_month_params)
          User.all.each do |user|
          if @attendance.overtime_instructor.to_i == user.id
            flash[:success] = "#{user.name}に申請しました。"
          end
        end
      else
        flash[:danger] = "申請ができませんでした"
      end
    redirect_to @user
  end

  #勤怠変更承認
  def notice_one_month
    @superior = User.find(params[:user_id])
    @attendance = Attendance.where(one_month_instructor: @superior,one_month_change: false)
    @attendance.each do |attendance|
      @users = User.find(attendance.user_id)
    end
  end

  def update_notice_one_month
    @user = User.find(params[:user_id])
    if one_month_approval_invalid?
      ActiveRecord::Base.transaction do
        notice_one_month_params.each do |id,item|
          attendance = Attendance.find(id)
          attendance.update_attributes(item)
        end
      end
      flash[:success] = "承認完了"
    end
      redirect_to user_url(@user)
  rescue ActiveRecord::RecordInvalid
    flash[:danger]="承認失敗"
    redirect_to user_url(@user)
  end

  #残業承認申請
  def notice_overtime
    @superior = User.find(params[:user_id])
    @attendance = Attendance.where(overtime_instructor: @superior,overtime_change: false)
    @attendance.each do |attendance|
      @users = User.find(attendance.user_id)
    end
  end

  def update_notice_overtime
    @user = User.find(params[:user_id])
    if overtime_approval_invalid?
      ActiveRecord::Base.transaction do
        notice_overtime_params.each do |id,item|
          attendance = Attendance.find(id)
          attendance.update_attributes(item)
        end
      end
      flash[:success] = "承認完了"
    end
      redirect_to user_url(@user)
  rescue ActiveRecord::RecordInvalid
    flash[:danger]="承認失敗"
    redirect_to user_url(@user)
  end

  #勤怠申請ログ
  def work_log
    @user = User.find(params[:id])
    @at = @user.attendances.where(id: @user.id)
    @at.each do |at_year|
    if at_year.worked_on.year == params[:work_year].to_i
      @at_year = @user.attendances.where(params[:user_id])
      @at_year.each do |at_month|
        if at_year.worked_on.month == params[:work_month].to_i
          @work_log = @user.attendances.where(params[:user_id])
        end
      end
    else
      @work_log = nil
    end
  end
    @year = (Date.current.year - 5)..Date.current.year
    @month = Date.current.change(month: 1).month..Date.current.change(month: 12).month
  end

  private
    def attendances_params
      params.require(:user).permit(attendances: [:started_at,:finished_at,:note,:one_month_instructor,:tomorrow])[:attendances]
    end

    def one_month_params
      params.require(:attendance).permit(:one_month_instructor)
    end

    def approval_params
      params.require(:attendance).permit(:instructor)
    end

    def notice_approval_params
      params.require(:user).permit(attendances: [:approval,:change])[:attendances]
    end

    def overtime_params
      params.require(:attendance).permit(:end_estimated_time,:overtime_tomorrow,:outline,:overtime_instructor)
    end

    def notice_one_month_params
      params.require(:user).permit(attendances: [:one_month_approval,:one_month_change])[:attendances]
    end

    def notice_overtime_params
      params.require(:user).permit(attendances: [:overtime_approval,:overtime_change])[:attendances]
    end

    def search_params
      params.require(:q).permit(:sorts)
    end
end
