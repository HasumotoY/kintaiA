module AttendancesHelper
require 'rounding'
  
  def working_times(start,finish)
    format("%.2f",(((finish.floor_to(15.minutes)-start.floor_to(15.minutes)) / 60)) / 60.0)
  end
  
  def attendances_invalid?
    attendances = true
    attendances_params.each do |id,item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:worked_on] == Date.today
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
  
  def over_times(estimated,designated)
    format("%.2f",(((estimated.floor_to(15.minutes)-designated) / 60)) / 60.0 )
  end
  
  def next_day_over_times(estimated,designated)
    format("%.2f",24 + (((estimated.floor_to(15.minutes)-designated) / 60)) / 60.0)
  end

  def attendances_each
    User.all.each do |user|
      attendances = Attendance.where(user_id: user.id)
      attendances.each do |at|
        if at.supporter.present? && (at.supporter.to_i == @user.id)
          @at = [user,at]
        end
      end
    end
  end
  
  def change(options)
    ::Date.new(
      options.fetch(:year, year),
      options.fetch(:month, month),
      options.fetch(:day, date)
    )
  end

  
  def user_id
    return @users[0][:id]
  end
  
  def attendance_id
    return Attendance.where(user_id: @users[0][:id], id: @attendance[1][:id])
  end
end
