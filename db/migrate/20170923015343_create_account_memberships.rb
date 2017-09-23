class CreateAccountMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :account_memberships do |t|
      t.references :user, foreign_key: true
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
