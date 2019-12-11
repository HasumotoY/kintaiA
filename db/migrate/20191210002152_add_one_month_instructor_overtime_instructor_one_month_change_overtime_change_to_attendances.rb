class AddOneMonthInstructorOvertimeInstructorOneMonthChangeOvertimeChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :one_month_instructor, :string
    add_column :attendances, :one_month_change, :boolean, default: false
    add_column :attendances, :overtime_instructor, :string
    add_column :attendances, :overtime_change, :boolean, default: false
  end
end
