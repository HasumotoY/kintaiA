class AddEndEstimatedTimeNextDayOutlineSupporterToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :end_estimated_time, :datetime
    add_column :attendances, :next_day, :boolean,default: false
    add_column :attendances, :outline, :string
    add_column :attendances, :supporter, :string
  end
end
