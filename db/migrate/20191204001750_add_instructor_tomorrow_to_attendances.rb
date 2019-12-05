class AddInstructorTomorrowToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :instructor, :string
    add_column :attendances, :tomorrow, :boolean,default: false
  end
end
