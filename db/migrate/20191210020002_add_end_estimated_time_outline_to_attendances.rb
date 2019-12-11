class AddEndEstimatedTimeOutlineToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :end_estimated_time, :datetime
    add_column :attendances, :outline, :string
  end
end
