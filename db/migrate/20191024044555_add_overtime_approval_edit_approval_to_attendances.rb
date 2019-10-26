class AddOvertimeApprovalEditApprovalToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_approval, :boolean
    add_column :attendances, :edit_approval, :boolean
  end
end
