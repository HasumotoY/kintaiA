class AddOneMonthChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :one_month_change, :boolean,default: false
  end
end
