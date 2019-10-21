class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  def set_one_month
    @first_day = params[:date].nil? ? 
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count
      ActiveRecord::Base.transaction do
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  rescue ActiveRecord::RecordInvalid
      flash[:danger]="ページ情報の取得に失敗しました。再アクセスしてください。"
      redirect_to root_url
  end
 
  def set_user
    @user = User.find(params[:id])
  end
    
  def admin_user
    unless current_user.admin?
      flash[:danger] = "管理者権限がありません。"
      redirect_to root_url
    end
  end
  
  def superior_user
    unless current_user.superior?
      flash[:danger] = "上長権限がありません。"
      redirect_to root_url
    end
  end
  
  def correct_user
    unless current_user?(@user)
      flash[:danger] = "他ユーザーの情報は閲覧・編集できません。"
      redirect_to(root_url)
    end
  end
  
  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    
    unless current_user?(@user) || current_user.admin?
      flash[:danger]="編集権限がありません。"
      redirect_to(root_url)
    end
  end
  
  def superior_or_correct_user
    @user = User.find(params[:id]) if @user.blank?
      unless current_user?(@user) || current_user.superior?
        flash[:danger]="閲覧権限がありません。"
        redirect_to(root_url)
      end
  end
  
  def modal_each
    @users = User.all
      @users.each do |user|
        attendance = Attendance.where(user_id: user.id)
          attendance.each do |at|
            @at = at
          end
      end
      
  end
end
