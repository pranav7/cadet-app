class AddIntercomDefaultBoardSlugToCompanySettings < ActiveRecord::Migration[5.2]
  def change
    add_column :company_settings, :intercom_default_board_slug, :string
  end
end
