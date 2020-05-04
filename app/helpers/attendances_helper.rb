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
      elsif Attendance.find(id).worked_on == Date.today
        next
      elsif item[:one_month_instructor].blank?
        attendances = false
        break
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
    format("%.2f",(((estimated.floor_to(15.minutes)-designated.floor_to(15.minutes)) / 60)) / 60.0 )
  end

  def next_day_over_times(estimated,designated)
    format("%.2f",24 + (((estimated.floor_to(15.minutes)-designated.floor_to(15.minutes)) / 60)) / 60.0)
  end

  def work_log_choices
    @user.attendances.all.map{|work_log| [work_log.worked_on,work_log.id]}
  end

  def change(options)
    ::Date.new(
      options.fetch(:year, year),
      options.fetch(:month, month),
      options.fetch(:day, date)
    )
  end

end
