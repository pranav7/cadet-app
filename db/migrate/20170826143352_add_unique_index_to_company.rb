class AddUniqueIndexToCompany < ActiveRecord::Migration[5.1]
  def change
    add_index :companies, :subdomain, unique: true
  end
end
