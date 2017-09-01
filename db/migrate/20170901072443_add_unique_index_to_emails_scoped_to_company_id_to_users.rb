class AddUniqueIndexToEmailsScopedToCompanyIdToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :email
    add_index :users, [:email, :company_id], unique: true
  end
end
