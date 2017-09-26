class ChangeMrrColumnInAccounts < ActiveRecord::Migration[5.1]
  def up
    remove_column :accounts, :mrr
    add_column :accounts, :mrr, :integer
  end

  def down
    remove_column :accounts, :mrr
    change_column :accounts, :mrr, :string
  end
end
