class AddOvertimeApprovalToAttendance < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_approval, :string
  end
end
