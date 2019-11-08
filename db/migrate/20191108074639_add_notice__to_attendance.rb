class AddNoticeToAttendance < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :notice, :integer
  end
end
