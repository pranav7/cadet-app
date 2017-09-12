class ChangeColumnTypeToReoleInMemberships < ActiveRecord::Migration[5.1]
  def change
    rename_column :memberships, :type, :role
  end
end
