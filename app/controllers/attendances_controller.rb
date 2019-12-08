class AttendancesController < ApplicationController
include AttendancesHelper
  
  before_action :set_user,only: [:edit_one_month]
  before_action :logged_in_user, only: [:update,:edit_one_month]
  before_action :set_one_month,only: [:edit_one_month]
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
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id,item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "勤怠を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効なデータがあったため、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
        
  def work_log
  end
  
  def search
  end
  
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
          if @attendance.supporter.to_i == user.id
            flash[:success] = "#{user.name}に残業を申請しました。"
          end
        end
      else
        flash[:danger] = "残業を申請できませんでした"
      end
    redirect_to @user
  end
  
  def notice_approval
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end
  
  def update_notice_approval
  end
  
  def notice_edit_one_month
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end
  
  def update_notice_edit_one_month
  end
  
  def notice_overtime
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end
  
  def update_notice_overtime
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
    @attendance.update_attributes(overtime_notice_params)
      if @attendance.change == true || @attendance.overtime_approval != "申請中"
        @attendance.supporter = nil
        flash[:success] = "申請処理が完了しました"
        redirect_to @user
      else
        flash[:danger] = "申請処理が失敗しました"
        redirect_to @user
      end
  end
        
  private
    def attendances_params
      params.require(:user).permit(attendances: [:started_at,:finished_at,:note,:instructor,:tomorrow])[:attettendances]
    end
    
    def overtime_params
      params.require(:attendance).permit(:end_estimated_time,:next_day,:outline,:supporter,:overtime_approval)
    end
    
    def overtime_notice_params
      params.require(:attendance).permit(:overtime_approval,:change)
    end
end
