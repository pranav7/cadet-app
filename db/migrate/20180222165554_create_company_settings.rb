class CreateCompanySettings < ActiveRecord::Migration[5.2]
  def change
    create_table :company_settings do |t|
      t.references :company, foreign_key: true
      t.datetime :expires_at
      t.string :billing_plan
      t.string :pricing_version

      t.timestamps
    end
  end
end
