class AddApiKeyToCompanySettings < ActiveRecord::Migration[5.2]
  def up
    add_column :company_settings, :api_key, :string
  end

  def down
    drop_column :company_settings, :api_key
  end
end
