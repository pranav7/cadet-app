class AddAddedByToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :added_by_id, :integer
  end
end
