module AttendancesHelper
require 'rounding'

  def working_times(attendance)
    if attendance.tomorrow == false
      format("%.2f",(((attendance.finished_at.floor_to(15.minutes)-attendance.started_at.floor_to(15.minutes)) / 60)) / 60.0)
    else
      format("%.2f",(((attendance.finished_at.floor_to(15.minutes)-attendance.started_at.floor_to(15.minutes)) / 60)) / 60.0 + 24)
    end
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

  def approval_invalid?
    approval = true
    notice_approval_params.each do |id,item|
      if item[:approval] == "承認" || item[:approval] == "否認"
        next
      elsif item[:change] = false
        approval = false
      else
        approval = false
      end
    end
      return approval
  end

  def one_month_approval_invalid?
    approval = true
    notice_one_month_approval_params.each do |id,item|
      if item[:one_month_approval] == "承認" || item[:one_month_approval] == "否認"
        next
      elsif item[:one_month_change] = false
        approval = false
      else
        approval = false
      end
    end
      return approval
  end

  def overtime_invalid?
    approval = true
    notice_overtime_approval_params.each do |id,item|
      if item[:overtime_approval] == "承認" || item[:overtime_approval] == "否認"
        next
      elsif item[:overtime_change] = false
        approval = false
      else
        approval = false
      end
    end
      return approval
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
