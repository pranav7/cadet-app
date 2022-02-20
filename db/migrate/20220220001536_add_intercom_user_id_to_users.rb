class AddIntercomUserIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :intercom_user_id, :string
    add_index :users, :intercom_user_id, unique: true
  end
end
