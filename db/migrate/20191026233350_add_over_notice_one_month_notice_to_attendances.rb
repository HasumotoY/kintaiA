class AddOverNoticeOneMonthNoticeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :over_notice, :string
    add_column :attendances, :one_month_notice, :string
  end
end
