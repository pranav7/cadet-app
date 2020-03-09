class AddIntercomAccessTokenForCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :company_settings, :intercom_access_token, :string
  end
end
