class AddCustomizableIntercomFieldsToCompanySettings < ActiveRecord::Migration[5.2]
  def change
    add_column :company_settings, :intercom_canvas_settings, :jsonb
  end
end
