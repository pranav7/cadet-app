class AddIntercomWorkspaceIdToCompanySettings < ActiveRecord::Migration[5.2]
  def change
    add_column :company_settings, :intercom_workspace_id, :string
  end
end
