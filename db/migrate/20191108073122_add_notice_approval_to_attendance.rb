class AddNoticeApprovalToAttendance < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :notice_approval, :string
  end
end
