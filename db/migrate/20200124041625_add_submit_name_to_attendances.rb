class AddSubmitNameToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :submit_name, :string
  end
end
