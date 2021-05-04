class AddDefaultValueToColumnIntercomCanvasSettings < ActiveRecord::Migration[5.2]
  def change
    change_column :company_settings, :intercom_canvas_settings, :jsonb, default: {}
  end
end
