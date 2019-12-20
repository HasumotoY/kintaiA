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
  
  def update_approval
  @user = User.find(params[:user_id])
    @attendance = @user.attendances.where(user_id: @user.id)
    @attendance.each do |attendance|
      if @approval_number > 0
        flash[:danger] = "同じ月の申請はできません"
      elsif attendance.approval.nil? || attendance.approval = "申請中"
        attendance.update_attributes(approval_params)
        flash[:success] = "所属長承認申請完了"
      else
        flash[:danger] = "申請処理が失敗しました"
      end
    end
    redirect_to @user
  end
  
  def notice_approval
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end
  
  def update_notice_approval
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
    @attendance.update_attributes(notice_approval_params)
      if @attendance.change == true || @attendance.approval != "申請中"
        @attendance.instructor = nil
        flash[:success] = "申請"
        redirect_to @user
      else
        flash[:danger] = "申請処理が失敗しました"
        redirect_to @user
      end
  end
  
  def notice_one_month
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end
  
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
  
  def notice_overtime
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end
  
  def update_notice_overtime
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
    @attendance.update_attributes(notice_overtime_params)
      if @attendance.overtime_change == true || @attendance.overtime_approval != "申請中"
        @attendance.overtime_instructor = nil
        flash[:success] = "申請処理が完了しました"
        redirect_to @user
      else
        flash[:danger] = "申請処理が失敗しました"
        redirect_to @user
      end
  end
        
  private
    def attendances_params
      params.require(:user).permit(attendances: [:started_at,:finished_at,:note,:one_month_instructor,:tomorrow])[:attendances]
    end
    
    def one_month_params
      params.require(:attendance).permit(:one_month_instructor,:overtime_approval)
    end
    
    def approval_params
      params.require(:attendance).permit(:instructor)
    end
    
    def notice_approval_params
      params.require(:attendance).permit(:approval,:change)
    end
    
    def overtime_params
      params.require(:attendance).permit(:end_estimated_time,:overtime_tomorrow,:outline,:overtime_instructor,:overtime_approval)
    end
    
    def one_month_notice_params
      params.require(:attendance).permit(:overtime_approval,:overtime_change)
    end

    def notice_one_month_params
      params.require(:attendance).permit(:one_month_approval,:one_month_change)
    end
    
    def notice_overtime_params
      params.require(:attendance).permit(:overtime_approval,:overtime_change)
    end
    
end
