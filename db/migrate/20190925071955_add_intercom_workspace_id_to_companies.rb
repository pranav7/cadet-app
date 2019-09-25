class AddIntercomWorkspaceIdToCompanies < ActiveRecord::Migration[5.2]
  def up
    add_column :companies, :intercom_workspace_id, :string
  end

  def down
    drop_column :companies, :intercom_workspace_id
  end
end
