class RemoveIndexOnCompany < ActiveRecord::Migration[5.2]
  def up
    remove_index :users, [:email, :company_id]
  end

  def down
    add_index :users, [:email, :company_id], unique: true
  end
end
