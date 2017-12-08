class AddAddedByIdToVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :added_by_id, :integer
  end
end
