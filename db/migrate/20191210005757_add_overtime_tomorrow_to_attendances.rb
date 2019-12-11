class AddOvertimeTomorrowToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_tomorrow, :boolean, default: false
  end
end
