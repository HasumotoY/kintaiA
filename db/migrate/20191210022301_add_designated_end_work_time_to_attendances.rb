class AddDesignatedEndWorkTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :designated_end_work_time, :datetime,default: Time.current.change(hour:18,min:0,sec:0)
  end
end
