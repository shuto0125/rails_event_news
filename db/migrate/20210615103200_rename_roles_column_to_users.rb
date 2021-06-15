class RenameRolesColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :roles, :role
  end
end
