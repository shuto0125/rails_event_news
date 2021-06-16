class AddRoleToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :roles, :integer, default: 3
  end
end
