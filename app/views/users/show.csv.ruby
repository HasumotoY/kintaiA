require 'csv'

CSV.generate do |csv|
  column_names = %w(worked_on started_at finished_at)
  csv << column_names
  @attendances.each do |attendance|
    if attendance.started_at.present? && attendance.finished_at.present? && attendance.one_month_approval.present?
      column_values = [
        attendance.worked_on,
        attendance.started_at,
        attendance.finished_at
      ]
      csv << column_values
    end
  end
end
