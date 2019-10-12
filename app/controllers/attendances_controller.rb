class AttendancesController < ApplicationController
  before_action :set_user,only: [:edit_one_month,:update_one_month,:edit_overtime,:update_overtime]
  before_action :logged_in_user, only: [:update,:edit_one_month,:edit_overtime]
  before_action :set_one_month,only: [:edit_one_month,:edit_ovetime]
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
      if attendances_invalid?
        ActiveRecord::Base.transaction do
          attendances_params.each do |id,item|
            attendance = Attendance.find(id)
            attendance.update_attributes!(item)
          end
        end  
        flash[:success] = "勤怠情報を更新しました。"
        redirect_to user_url(date: params[:date])
      else
        flash[:danger]="無効な時刻入力がありました。やり直してください。"
        redirect_to attendances_edit_one_month_user_url(date: params[:date])
      end
  
  
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = UPDATE_ERROR_MSG
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def edit_overtimeend
  end
  
  def update_overtime
    overtime_params.each do |id,item|
    @attendance = Attendance.find(params[:id])
      if  @attendance.update_attributes(item)
        flash[:success] = "残業申請完了"
      else
        flash[:danger] = "残業申請失敗"
      end
    redirect_to @user
    end
  end
  
  
  private
    def attendances_params
      params.require(:user).permit(attendances: [:started_at,:finished_at,:note,:worked_on])[:attendances]
    end
    
    def overtime_params
      params.require(:user).permit(attendances: [:end_estimated_time,:next_day,:outline,:supporter])[:attendances]
    end
    
    def attendances_invalid?
      attendances = true
      attendances_params.each do |id,item|
        unless Date.current == item[:worked_on]
          if item[:started_at].blank? && item[:finished_at].blank?
            next
          elsif item[:started_at] > item[:finished_at]
            attendances = false
            break
          elsif item[:started_at].blank? || item[:finished_at].blank?
            attendances = false
            break
          end
        end
        return attendances
      end
    end
end
