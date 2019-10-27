class AddOverApprovalOneMonthApprovalToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :over_approval, :integer
    add_column :attendances, :one_month_approval, :integer
  end
end
