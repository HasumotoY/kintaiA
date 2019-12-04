class AddInstructorTomorrowToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :instructor, :string,default: false
    add_column :attendances, :tomorrow, :boolean
  end
end
