class AddApproval2Change2Instructor2ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :approval2, :string
    add_column :users, :change2, :boolean,default: false
    add_column :users, :instructor2, :string
  end
end
