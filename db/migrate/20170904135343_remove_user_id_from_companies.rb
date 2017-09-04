class RemoveUserIdFromCompanies < ActiveRecord::Migration[5.1]
  def change
    remove_column :companies, :user_id
  end
end
