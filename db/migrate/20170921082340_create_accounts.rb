class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :domain
      t.references :company, foreign_key: true
      t.boolean :paying, default: false
      t.boolean :churned, default: false
      t.string :mrr

      t.timestamps
    end
  end
end
